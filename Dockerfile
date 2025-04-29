FROM public.ecr.aws/lambda/python:3.13@sha256:0ea161a9d9a00df9c9e26a8b31d87f6ba96a1fdb5d46479d2910e75b0d47414e

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
