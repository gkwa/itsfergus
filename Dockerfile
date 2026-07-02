FROM public.ecr.aws/lambda/python:3.14@sha256:7c888beef7da6141cbeef75c2bffdc6443f26eb1df0865e159ba0d5eb3cf190f

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
