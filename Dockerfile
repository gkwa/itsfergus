FROM public.ecr.aws/lambda/python:3.13@sha256:11f562115ca14c92740459230f0a6c0dbf8d27152400f852856d73e0a924a0a0

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
