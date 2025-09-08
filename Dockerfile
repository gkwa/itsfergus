FROM public.ecr.aws/lambda/python:3.13@sha256:2b544cff03a43e1514154ee0d4a4d69413ff67838fa5a8005cf0379714f1323b

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
