FROM public.ecr.aws/lambda/python:3.13@sha256:289bf644a66a9ddd12de0b5f8b690ed82d125384653e0f1857f9de4c74f7a0f1

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
