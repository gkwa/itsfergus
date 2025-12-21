FROM public.ecr.aws/lambda/python:3.14@sha256:0800b32f3f487ba4f998a44a3e28e653d7d52eb22636f5156770013af3ad1fee

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
