set shell := ["bash", "-uec"]
set export := true

AWS_PROFILE := env_var_or_default("AWS_PROFILE", "default")
AWS_REGION := env_var_or_default("AWS_REGION", "ca-central-1")
ECR_REPO := "lambda-docker-repo"
LAMBDA_NAME := "docker-lambda-function"
DEBUG := env_var_or_default("ITSFERGUS_DEBUG", "")

[group('maint')]
default:
    @just --list

[group('setup')]
_init-tf:
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    terraform init -upgrade

[group('setup')]
_tf-init-ecr: _init-tf
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    terraform apply -auto-approve -target=aws_ecr_repository.app_repo

[group('test')]
recur-apitest-iam: _install-recur
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    recur --verbose --timeout 2s --attempts 4 --backoff 3s just apitest-iam

[group('test')]
recur-apitest-key: _install-recur
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    recur --verbose --timeout 2s --attempts 4 --backoff 3s just apitest-key

[group('setup')]
setup-iam: _install-recur _tf-init-ecr _docker-build _tf-apply-iam (init-env "iam") recur-apitest-iam

[group('setup')]
setup-key: _install-recur _tf-init-ecr _docker-build _tf-apply-key (init-env "key") recur-apitest-key

[group('teardown')]
destroy-iam: _init-tf _tf-destroy-iam

[group('teardown')]
destroy-key: _init-tf _tf-destroy-key

[group('teardown')]
cleanup-kms-grants:
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    bash -euo pipefail ${DEBUG:+-x} check-kms-grants.sh
    bash -euo pipefail ${DEBUG:+-x} cleanup_kms_grants.sh
    bash -euo pipefail ${DEBUG:+-x} check-kms-grants.sh

[group('setup')]
_install-recur:
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    if ! command -v recur >/dev/null 2>&1; then
        GOBIN=/usr/local/bin go install github.com/dbohdan/recur/v2@latest
    fi

[group('setup')]
_docker-build:
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
    aws ecr get-login-password --region {{ AWS_REGION }} | \
        docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.{{ AWS_REGION }}.amazonaws.com
    docker build -t {{ ECR_REPO }} .
    docker tag {{ ECR_REPO }}:latest $AWS_ACCOUNT_ID.dkr.ecr.{{ AWS_REGION }}.amazonaws.com/{{ ECR_REPO }}:latest
    docker push $AWS_ACCOUNT_ID.dkr.ecr.{{ AWS_REGION }}.amazonaws.com/{{ ECR_REPO }}:latest

[group('setup')]
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

[group('teardown')]
_tf-destroy-iam:
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    terraform destroy -auto-approve -var="auth_type=iam"

[group('teardown')]
_tf-destroy-key:
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    terraform destroy -auto-approve -var="auth_type=key"

[group('teardown')]
_remove_dot_env:
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    rm -f .env

[group('test')]
apitestpython-key: _install-recur
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    set -a; source .env; set +a
    uv sync --quiet
    . .venv/bin/activate
    recur --verbose --timeout 2s --attempts 10 --backoff 3s python apitest-key.py

[group('test')]
apitestpython-iam: _install-recur
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    set -a; source .env; set +a
    uv sync --quiet
    . .venv/bin/activate
    recur --verbose --timeout 2s --attempts 10 --backoff 3s python apitest-iam.py

[group('test')]
test-multiple test_type sleep_on_first_loop_yesno="no":
    #!/usr/bin/env bash

    # Save the current debug state before setting options
    [[ $- == *x* ]] && DEBUG_ENABLED=true || DEBUG_ENABLED=false

    set -euo pipefail ${DEBUG:+-x}

    source test-multiple.sh

    # Propagate debug state to the environment for the sourced script
    export TRACE=${DEBUG_ENABLED}
    SLEEP_TIME_SECONDS=$(units --terse 10min sec)
    run_test {{ test_type }} $SLEEP_TIME_SECONDS $sleep_on_first_loop_yesno

[group('maint')]
config:
    #!/usr/bin/env bash
    cat >/tmp/o1 <<'EOF1'
    for f in ~/.profile ~/.bashrc; do
        grep -q 'if command -v just' $f 2>/dev/null || cat >> $f << 'EOF'
    if command -v just &>/dev/null; then eval "$(just --completions bash 2>/dev/null)"; fi
    EOF
    source ~/.profile
    source ~/.bashrc
    done

    for f in ~/.profile ~/.bashrc; do
        grep -q 'alias j=just' $f 2>/dev/null || cat >> $f << 'EOF'
    alias j=just
    EOF
    source ~/.profile
    source ~/.bashrc
    done
    EOF1

[group('runner')]
start-runner: config _start-runner install-monitor

[group('runner')]
_start-runner:
    #!/usr/bin/env bash

    cat >start-runner.sh<<'EOF'
    #!/usr/bin/env bash

    echo $$ >~/itsfergus.pid
    for i in {1..10}; do
        ITSFERGUS_DEBUG=1 just --timestamp test-multiple-iam
    done
    EOF
    chmod +x start-runner.sh
    nohup bash -x start-runner.sh &

[group('test')]
test-multiple-key: install-monitor (test-multiple "key")

[group('test')]
test-multiple-iam: install-monitor (test-multiple "iam")

[group('debug')]
debug:
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    outfile=$(mktemp output-XXXX.json) && \
        aws lambda invoke --function-name docker-lambda-function \
            --region {{ AWS_REGION }} --payload '{}' $outfile; rm -f $outfile

# https://repost.aws/knowledge-center/lambda-kmsaccessdeniedexception-errors
[group('debug')]
kms-fix:
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    bash -euo pipefail ${DEBUG:+-x} kms-fix.sh

# https://repost.aws/knowledge-center/lambda-kmsaccessdeniedexception-errors
[group('debug')]
kms-fix2:
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    bash -euo pipefail ${DEBUG:+-x} kms-fix2.sh

# https://repost.aws/knowledge-center/lambda-kmsaccessdeniedexception-errors
[group('debug')]
kms-fix3:
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    bash -euo pipefail ${DEBUG:+-x} kms-fix3.sh

[group('debug')]
check-quotas:
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    bash -euo pipefail ${DEBUG:+-x} check-quotas.sh

[group('monitor')]
check-monitor:
    find /etc/cron.d/
    journalctl --unit=cron.service --follow

[group('monitor')]
install-monitor:
    #!/usr/bin/env bash
    rm -f /etc/cron.d/monitor-itsfergus
    rm -f /root/monitor-itsfergus.sh

    cat > /root/monitor-itsfergus.sh << 'EOF'
    #!/bin/bash
    pid_file=/root/itsfergus.pid


    if [ -f $pid_file ] && ! kill -0 $(cat $pid_file) 2>/dev/null; then
        curl -d "process itsfergus failed" ntfy.sh/mtmonacelli-itsfergus
        rm /etc/cron.d/monitor-itsfergus # only alert once
    fi
    EOF

    cat > /etc/cron.d/monitor-itsfergus << 'EOF'
    * * * * * root /root/monitor-itsfergus.sh

    EOF
    chmod +x /root/monitor-itsfergus.sh

    echo updated:
    ls /etc/cron.d/monitor-itsfergus
    ls /root/monitor-itsfergus.sh

[group('test')]
apitest-iam: apitesthurl-iam apitestpython-iam apitestbash-iam

[group('test')]
apitest-key: apitesthurl-key apitestpython-key apitestbash-key

[group('test')]
apitesthurl-key: _install-recur
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    hurl --connect-timeout=10 --retry=10 --jobs=1 --repeat=1 \
        --test --variables-file=.env apitest-key.hurl

[group('test')]
apitesthurl-iam:
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    hurl --connect-timeout=10 --retry=10 --jobs=1 --repeat=1 \
        --test --variable "DateTime=$(date -u +%Y%m%dT%H%M%SZ)" \
        --variables-file=.env apitest-iam.hurl

[group('test')]
apitestbash-key:
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    bash -euo pipefail ${DEBUG:+-x} apitest-key.sh

[group('test')]
apitestbash-iam:
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    bash -euo pipefail ${DEBUG:+-x} apitest-iam.sh

[group('debug')]
logs:
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    aws logs tail "/aws/lambda/{{ LAMBDA_NAME }}" --since 1h --follow

# prettify files
[group('maint')]
fmt:
    shfmt -w -s -i 4 *.sh
    terraform fmt -recursive .
    prettier --ignore-path=.prettierignore --config=.prettierrc.json --write .
    ruff check . --fix
    ruff format .
    just --unstable --fmt

[group('teardown')]
_cleanup_kms_grants:
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    bash -euo pipefail ${DEBUG:+-x} cleanup_kms_grants.sh

[group('debug')]
check-all-kms-grants:
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    bash -euo pipefail ${DEBUG:+-x} check-all-kms-grants.sh

[group('debug')]
check-kms-grants:
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    bash -euo pipefail ${DEBUG:+-x} check-kms-grants.sh

[group('debug')]
check-kms-metrics duration="5m" timezone="America/Los_Angeles":
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    bash -euo pipefail ${DEBUG:+-x} check-kms-metrics.sh {{ duration }} {{ timezone }}

[group('debug')]
check-api-throttling duration="5m":
    #!/usr/bin/env bash
    set -euo pipefail ${DEBUG:+-x}

    AWS_REGION={{ AWS_REGION }} bash -euo pipefail ${DEBUG:+-x} check-api-throttling.sh {{ duration }}

[group('teardown')]
teardown: _remove_dot_env _cleanup_kms_grants destroy-iam destroy-key
