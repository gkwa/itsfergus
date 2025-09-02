FROM public.ecr.aws/lambda/python:3.13@sha256:27b4e525f1ab1adac13bf3f35cf7a77a79e6a6ccd0c959a54a3653b1ae7d5288

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
