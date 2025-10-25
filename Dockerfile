FROM public.ecr.aws/lambda/python:3.13@sha256:7c72aeb72983041707b0a5e201b0859397b81948678f823df019c0b7b676b86e

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
