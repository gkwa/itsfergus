FROM public.ecr.aws/lambda/python:3.13@sha256:1c872d116803f1c6f46f224146969c4adbb0da11a565eb9fe166ec33dd12e5fb

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
