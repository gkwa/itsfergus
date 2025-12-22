FROM public.ecr.aws/lambda/python:3.14@sha256:834867e65287508faae9d0706181e3e5c72fe8d9b99319c6ab1096ce1494c4a4

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
