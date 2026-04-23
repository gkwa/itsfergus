FROM public.ecr.aws/lambda/python:3.14@sha256:2c82ed8cd633a5b4613016f1dc422109e6cd06998a33671f2a4fc5c3a8d13100

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
