FROM public.ecr.aws/lambda/python:3.15@sha256:0fe356197db0b8896f1116301e77ea4e9c0c3f16db5a10c8a52afbde32aeb35e

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
