FROM public.ecr.aws/lambda/python:3.14@sha256:132a5d5b6fcf9578d28a00e2a0e6c121306e9464cfb5535088912a570ae03ab4

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
