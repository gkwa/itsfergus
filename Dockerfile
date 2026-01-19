FROM public.ecr.aws/lambda/python:3.14@sha256:5ec375e564d79e5d5d18cc8167d9ee9a7a67c931210ed95c508e3be4fcc847ca

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
