FROM public.ecr.aws/lambda/python:3.14@sha256:9cbf5ef2a97ec6f7956b87fe6b07810016ea3cd3f6d35e0157a5c6c1fc4607d8

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
