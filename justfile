set shell := ["bash", "-uec"]
set export := true

AWS_PROFILE := env_var_or_default("AWS_PROFILE", "default")
AWS_REGION := env_var_or_default("AWS_REGION", "ca-central-1")
ECR_REPO := "lambda-docker-repo"
LAMBDA_NAME := "docker-lambda-function"
DEBUG := env_var_or_default("ITSFERGUS_DEBUG", "")

default:
    @just --list

_init-tf:
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    terraform init -upgrade

_tf-init-ecr: _init-tf
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    terraform apply -auto-approve -target=aws_ecr_repository.app_repo

recur-apitest-iam: _install-recur
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    recur --verbose --timeout 2s --attempts 4 --backoff 3s just apitest-iam

recur-apitest-key: _install-recur
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    recur --verbose --timeout 2s --attempts 4 --backoff 3s just apitest-key

setup-iam: _install-recur _tf-init-ecr _docker-build _tf-apply-iam (init-env "iam") recur-apitest-iam

setup-key: _install-recur _tf-init-ecr _docker-build _tf-apply-key (init-env "key") recur-apitest-key

destroy-iam: _init-tf _tf-destroy-iam

destroy-key: _init-tf _tf-destroy-key

cleanup-kms-grants:
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    bash -euo pipefail ${DEBUG:+-x} check-kms-grants.sh
    bash -euo pipefail ${DEBUG:+-x} cleanup_kms_grants.sh
    bash -euo pipefail ${DEBUG:+-x} check-kms-grants.sh

_install-recur:
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    if ! command -v recur >/dev/null 2>&1; then
        GOBIN=/usr/local/bin go install github.com/dbohdan/recur/v2@latest
    fi

_docker-build:
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
    aws ecr get-login-password --region {{ AWS_REGION }} | \
        docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.{{ AWS_REGION }}.amazonaws.com
    docker build -t {{ ECR_REPO }} .
    docker tag {{ ECR_REPO }}:latest $AWS_ACCOUNT_ID.dkr.ecr.{{ AWS_REGION }}.amazonaws.com/{{ ECR_REPO }}:latest
    docker push $AWS_ACCOUNT_ID.dkr.ecr.{{ AWS_REGION }}.amazonaws.com/{{ ECR_REPO }}:latest

init-env AUTH_TYPE:
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    if [ ! -f .env ]; then
        AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
        if [ "{{ AUTH_TYPE }}" = "iam" ]; then
            ROLE_ARN=$(terraform output -raw api_invocation_role_arn)
            CREDS=$(aws sts assume-role --role-arn $ROLE_ARN --role-session-name test-session)
            echo "AWS_ACCESS_KEY_ID=$(echo $CREDS | jq -r .Credentials.AccessKeyId)" > .env
            echo "AWS_SECRET_ACCESS_KEY=$(echo $CREDS | jq -r .Credentials.SecretAccessKey)" >> .env
            echo "AWS_SESSION_TOKEN=$(echo $CREDS | jq -r .Credentials.SessionToken)" >> .env
        fi
        API_URL=$(terraform output -raw api_gateway_url)
        echo "AWS_ACCOUNT_ID=$AWS_ACCOUNT_ID" >> .env
        echo "AWS_REGION={{ AWS_REGION }}" >> .env
        echo "ECR_REPO={{ ECR_REPO }}" >> .env
        echo "API_URL=$API_URL" >> .env
        API_HOST=$(echo "$API_URL" | sed 's|^https://||' | sed 's|/$||')
        echo "API_HOST=$API_HOST" >> .env

        if [ "{{ AUTH_TYPE }}" = "key" ]; then
            API_KEY=$(terraform output -raw api_key)
            echo "API_KEY=$API_KEY" >> .env
        fi
    fi

_tf-apply-iam:
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    terraform apply -auto-approve -var="auth_type=iam"

_tf-apply-key:
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    terraform apply -auto-approve -var="auth_type=key"

_tf-destroy-iam:
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    terraform destroy -auto-approve -var="auth_type=iam"

_tf-destroy-key:
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    terraform destroy -auto-approve -var="auth_type=key"

_remove_dot_env:
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    rm -f .env

apitestpython-key: _install-recur
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    set -a; source .env; set +a
    uv sync --quiet
    . .venv/bin/activate
    recur --verbose --timeout 2s --attempts 10 --backoff 3s python apitest-key.py

apitestpython-iam: _install-recur
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    set -a; source .env; set +a
    uv sync --quiet
    . .venv/bin/activate
    recur --verbose --timeout 2s --attempts 10 --backoff 3s python apitest-iam.py

test-mutliple test_type sleep_on_first_loop_yesno="no":
    #!/usr/bin/env bash

    # Save the current debug state before setting options
    [[ $- == *x* ]] && DEBUG_ENABLED=true || DEBUG_ENABLED=false

    set -euo pipefail ${DEBUG:+-x}

    source test-multiple.sh

    # Propagate debug state to the environment for the sourced script
    export TRACE=${DEBUG_ENABLED}
    SLEEP_TIME_SECONDS=$(units --terse 8min sec)
    run_test {{ test_type }} $SLEEP_TIME_SECONDS $sleep_on_first_loop_yesno

test-multiple-key: (test-mutliple "key")

test-multiple-iam: (test-mutliple "iam")

debug:
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    outfile=$(mktemp output-XXXX.json) && \
        aws lambda invoke --function-name docker-lambda-function \
            --region {{ AWS_REGION }} --payload '{}' $outfile; rm -f $outfile

# https://repost.aws/knowledge-center/lambda-kmsaccessdeniedexception-errors
kms-fix:
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    bash -euo pipefail ${DEBUG:+-x} kms-fix.sh

# https://repost.aws/knowledge-center/lambda-kmsaccessdeniedexception-errors
kms-fix2:
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    bash -euo pipefail ${DEBUG:+-x} kms-fix2.sh

# https://repost.aws/knowledge-center/lambda-kmsaccessdeniedexception-errors
kms-fix3:
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    bash -euo pipefail ${DEBUG:+-x} kms-fix3.sh

check-quotas:
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    bash -euo pipefail ${DEBUG:+-x} check-quotas.sh

install-monitor:
    rm -f /etc/cron.d/monitor-itsfergus
    rm -f /root/monitor-itsfergus.sh

    cat > /root/monitor-itsfergus.sh << 'EOF'
    #!/bin/bash
    pid_file="/root/itsfergus.pid"

    if [ -f $pid_file ] && ! kill -0 $(cat $pid_file) 2>/dev/null; then
        curl -d "process failed" ntfy.sh/mtmonacelli-itsfergus
        rm /etc/cron.d/monitor-itsfergus
    fi
    EOF

    cat > /etc/cron.d/monitor-itsfergus << 'EOF'
    * * * * * root /root/monitor-itsfergus.sh

    EOF
    chmod +x /root/monitor-itsfergus.sh

    cat /etc/cron.d/monitor-itsfergus
    cat /root/monitor-itsfergus.sh

    journalctl -u cron.service --follow



s1-iam: cleanup-kms-grants teardown setup-iam

apitest-iam: apitesthurl-iam apitestpython-iam apitestbash-iam

apitest-key: apitesthurl-key apitestpython-key apitestbash-key

apitesthurl-key: _install-recur
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    hurl --connect-timeout=10 --retry=10 --jobs=1 --repeat=1 \
        --test --variables-file=.env apitest-key.hurl

apitesthurl-iam:
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    hurl --connect-timeout=10 --retry=10 --jobs=1 --repeat=1 \
        --test --variable "DateTime=$(date -u +%Y%m%dT%H%M%SZ)" \
        --variables-file=.env apitest-iam.hurl

apitestbash-key:
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    bash -euo pipefail ${DEBUG:+-x} apitest-key.sh

apitestbash-iam:
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    bash -euo pipefail ${DEBUG:+-x} apitest-iam.sh

logs:
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    aws logs tail "/aws/lambda/{{ LAMBDA_NAME }}" --since 1h --follow

# prettify files
fmt:
    shfmt -w -s -i 4 *.sh
    terraform fmt -recursive .
    prettier --ignore-path=.prettierignore --config=.prettierrc.json --write .
    ruff check . --fix
    ruff format .
    just --unstable --fmt

_cleanup_kms_grants:
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    bash -euo pipefail ${DEBUG:+-x} cleanup_kms_grants.sh

check-all-kms-grants:
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    bash -euo pipefail ${DEBUG:+-x} check-all-kms-grants.sh

check-kms-grants:
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    bash -euo pipefail ${DEBUG:+-x} check-kms-grants.sh

check-kms-metrics duration="5m" timezone="America/Los_Angeles":
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    bash -euo pipefail ${DEBUG:+-x} check-kms-metrics.sh {{ duration }} {{ timezone }}

check-api-throttling duration="5m":
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    AWS_REGION={{ AWS_REGION }} bash -euo pipefail ${DEBUG:+-x} check-api-throttling.sh {{ duration }}

teardown: _remove_dot_env _cleanup_kms_grants destroy-iam destroy-key
