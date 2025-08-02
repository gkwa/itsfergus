FROM public.ecr.aws/lambda/python:3.13@sha256:1e7a90ddd02e0c216fd594d70e5d9892415f5f66fa827fc260c2c933aba2aecb

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
