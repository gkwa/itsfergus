set export := true

AWS_PROFILE := env_var_or_default("AWS_PROFILE", "default")
AWS_REGION := env_var_or_default("AWS_REGION", "ca-central-1")
ECR_REPO := "lambda-docker-repo"
LAMBDA_NAME := "docker-lambda-function"

default:
    @just --list

_init-tf:
    terraform init -upgrade

_tf-init-ecr: _init-tf
    terraform apply -auto-approve -target=aws_ecr_repository.app_repo

recur-apitest-iam: _install-recur
    #!/usr/bin/env bash
    recur --verbose --timeout 2s --attempts 4 --backoff 3s just apitest-iam

recur-apitest-key: _install-recur
    #!/usr/bin/env bash
    recur --verbose --timeout 2s --attempts 4 --backoff 3s just apitest-key

setup-iam: _install-recur _tf-init-ecr _docker-build _tf-apply-iam (init-env "iam") recur-apitest-iam

setup-key: _install-recur _tf-init-ecr _docker-build _tf-apply-key (init-env "key") recur-apitest-key

destroy-iam: _init-tf _tf-destroy-iam

destroy-key: _init-tf _tf-destroy-key

cleanup-kms-grants:
    ./check-kms-grants.sh
    ./cleanup_kms_grants.sh
    ./check-kms-grants.sh

_install-recur:
    #!/usr/bin/env bash
    if ! command -v recur >/dev/null 2>&1; then
        GOBIN=/usr/local/bin go install github.com/dbohdan/recur/v2@latest
    fi

_docker-build:
    #!/usr/bin/env bash
    set -euo pipefail
    AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
    aws ecr get-login-password --region {{ AWS_REGION }} | \
        docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.{{ AWS_REGION }}.amazonaws.com
    docker build -t {{ ECR_REPO }} .
    docker tag {{ ECR_REPO }}:latest $AWS_ACCOUNT_ID.dkr.ecr.{{ AWS_REGION }}.amazonaws.com/{{ ECR_REPO }}:latest
    docker push $AWS_ACCOUNT_ID.dkr.ecr.{{ AWS_REGION }}.amazonaws.com/{{ ECR_REPO }}:latest

init-env AUTH_TYPE:
    #!/usr/bin/env bash
    set -euo pipefail
    set -x
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
    terraform apply -auto-approve -var="auth_type=iam"

_tf-apply-key:
    terraform apply -auto-approve -var="auth_type=key"

_tf-destroy-iam:
    terraform destroy -auto-approve -var="auth_type=iam"

_tf-destroy-key:
    terraform destroy -auto-approve -var="auth_type=key"

_remove_dot_env:
    rm -f .env

apitestpython-key: _install-recur
    #!/usr/bin/env bash
    set -a; source .env; set +a
    uv sync --quiet
    . .venv/bin/activate
    recur --verbose --timeout 2s --attempts 10 --backoff 3s python apitest-key.py

apitestpython-iam: _install-recur
    #!/usr/bin/env bash
    set -a; source .env; set +a
    uv sync --quiet
    . .venv/bin/activate
    recur --verbose --timeout 2s --attempts 10 --backoff 3s python apitest-iam.py

test-multiple-iam:
    #!/usr/bin/env bash
    set -e
    logfile="test-multiple-iam-$(date +%Y%m%d-%H%M%S).log"
    echo "Starting test run at $(date -u)" > "$logfile"

    # Get sleep duration from environment variable, default to 0
    SLEEP_TIME=${SLEEP_TIME:-20}
    echo "Using sleep time of ${SLEEP_TIME} seconds" | tee -a "$logfile"

    for i in {1..10}; do
        echo -e "\n=== Iteration $i starting at $(date -u) ===" | tee -a "$logfile"

        echo "Grants before iteration $i:" | tee -a "$logfile"
        ./check-kms-grants.sh >> "$logfile" 2>&1

        if ! (just teardown setup-iam); then
            echo "Failed at iteration $i at $(date -u)" | tee -a "$logfile"
            echo "Final grant state:" | tee -a "$logfile"
            ./check-kms-grants.sh >> "$logfile" 2>&1
            echo "Running debug:" | tee -a "$logfile"
            just debug >> "$logfile" 2>&1
            exit 1
        fi

        echo "Iteration $i succeeded" | tee -a "$logfile"

        echo "Grants after iteration $i:" | tee -a "$logfile"
        ./check-kms-grants.sh >> "$logfile" 2>&1

        if [ "$SLEEP_TIME" -gt 0 ]; then
            echo "Sleeping for ${SLEEP_TIME} seconds..." | tee -a "$logfile"
            sleep "$SLEEP_TIME"
        fi
    done

    echo "All iterations completed successfully at $(date -u)" | tee -a "$logfile"

test-multiple-key:
    #!/usr/bin/env bash
    set -e
    logfile="test-multiple-key-$(date +%Y%m%d-%H%M%S).log"
    echo "Starting test run at $(date -u)" > "$logfile"

    # Get sleep duration from environment variable, default to 0
    SLEEP_TIME=${SLEEP_TIME:-20}
    echo "Using sleep time of ${SLEEP_TIME} seconds" | tee -a "$logfile"

    for i in {1..10}; do
        echo -e "\n=== Iteration $i starting at $(date -u) ===" | tee -a "$logfile"

        echo "Grants before iteration $i:" | tee -a "$logfile"
        ./check-kms-grants.sh >> "$logfile" 2>&1

        if ! (just teardown setup-key); then
            echo "Failed at iteration $i at $(date -u)" | tee -a "$logfile"
            echo "Final grant state:" | tee -a "$logfile"
            ./check-kms-grants.sh >> "$logfile" 2>&1
            echo "Running debug:" | tee -a "$logfile"
            just debug >> "$logfile" 2>&1
            exit 1
        fi

        echo "Iteration $i succeeded" | tee -a "$logfile"

        echo "Grants after iteration $i:" | tee -a "$logfile"
        ./check-kms-grants.sh >> "$logfile" 2>&1

        if [ "$SLEEP_TIME" -gt 0 ]; then
            echo "Sleeping for ${SLEEP_TIME} seconds..." | tee -a "$logfile"
            sleep "$SLEEP_TIME"
        fi
    done

    echo "All iterations completed successfully at $(date -u)" | tee -a "$logfile"

test-multiple-iam2:
    #!/usr/bin/env bash
    set -e
    >test-multiple-iam2.log
    for i in {1..10}; do
        rm -f .env
        if ! (just setup-iam); then
            just debug
            exit 1
        fi
        echo $i >test-multiple-iam2.log
    done

test-multiple-key2:
    #!/usr/bin/env bash
    set -e
    >test-multiple-key2.log
    for i in {1..10}; do
        rm -f .env
        if ! (just setup-key); then
            just debug
            exit 1
        fi
        echo $i >test-multiple-key2.log
    done

debug:
    #!/usr/bin/env bash
    REGION={{ AWS_REGION }}

    set -e
    outfile=$(mktemp output-XXXX.json); aws lambda invoke --function-name docker-lambda-function --region $REGION --payload '{}' $outfile; rm -f $outfile

# https://repost.aws/knowledge-center/lambda-kmsaccessdeniedexception-errors
kms-fix:
    ./kms-fix.sh

# https://repost.aws/knowledge-center/lambda-kmsaccessdeniedexception-errors
kms-fix2:
    ./kms-fix2.sh

# https://repost.aws/knowledge-center/lambda-kmsaccessdeniedexception-errors
kms-fix3:
    ./kms-fix3.sh

check-quotas:
    ./check-quotas.sh

s1-iam: cleanup-kms-grants teardown setup-iam

apitest-iam: apitesthurl-iam apitestpython-iam apitestbash-iam

apitest-key: apitesthurl-key apitestpython-key apitestbash-key

apitesthurl-key: _install-recur
    #!/usr/bin/env bash
    hurl --connect-timeout=10 --retry=10 --jobs=1 --repeat=1 --test --variables-file=.env apitest-key.hurl

apitesthurl-iam:
    #!/usr/bin/env bash
    hurl --connect-timeout=10 --retry=10 --jobs=1 --repeat=1 --test --variable "DateTime=$(date -u +%Y%m%dT%H%M%SZ)" --variables-file=.env apitest-iam.hurl

apitestbash-key:
    ./apitest-key.sh

apitestbash-iam:
    ./apitest-iam.sh

logs:
    aws logs tail "/aws/lambda/{{ LAMBDA_NAME }}" --since 1h --follow

fmt:
    shfmt -w -s -i 4 *.sh
    terraform fmt -recursive .
    prettier --ignore-path=.prettierignore --config=.prettierrc.json --write .
    ruff check . --fix
    ruff format .
    just --unstable --fmt

_cleanup_kms_grants:
    ./cleanup_kms_grants.sh

check-all-kms-grants:
    ./check-all-kms-grants.sh

check-kms-grants:
    ./check-kms-grants.sh

check-kms-metrics duration="5m" timezone="America/Los_Angeles":
    ./check-kms-metrics.sh {{ duration }} {{ timezone }}

check-api-throttling duration="5m":
    ./check-api-throttling.sh {{ duration }}

teardown: _remove_dot_env _cleanup_kms_grants destroy-iam destroy-key
