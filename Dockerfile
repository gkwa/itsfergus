FROM public.ecr.aws/lambda/python:3.13@sha256:9207a0fbe0baed11712bc0b6ced5906602ad12f41d2250f0ae9fc175fc30bea4

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
