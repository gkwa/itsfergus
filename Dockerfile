FROM public.ecr.aws/lambda/python:3.14@sha256:71c831d25a4c5cdcf9b28b57758c3d186ff28a3f43ed1fe43a1840b4a959e653

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
