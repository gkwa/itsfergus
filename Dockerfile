FROM public.ecr.aws/lambda/python:3.14@sha256:f4e4b5916d9898f889509caf790cf624bde23c166d440023d64de2e02e027ce0

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
