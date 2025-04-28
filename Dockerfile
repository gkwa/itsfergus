FROM public.ecr.aws/lambda/python:3.13@sha256:8a63c710fa487627e2ff45a86a625f6ff7b27b10e769d75743eab493a14c12d1

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
