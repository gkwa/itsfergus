FROM public.ecr.aws/lambda/python:3.13@sha256:16281389f5a8c0f12adee4b265b18b8b89d5b60ffdc649b3432291d914c9ca1c

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
