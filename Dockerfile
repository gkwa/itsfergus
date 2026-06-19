FROM public.ecr.aws/lambda/python:3.14@sha256:0dc5d7bcc825ebef99f9ace2758beda66b2b1a88f5034a61d20c2e67a4d30cf1

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
