FROM public.ecr.aws/lambda/python:3.14@sha256:5fb6b96b3c50c495456bfc6607ad51315b92bbb247a3a0c51c2bfc08ff23e2e6

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
