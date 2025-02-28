FROM public.ecr.aws/lambda/python:3.13@sha256:469e3c6f4d68e240babce9e3f916a4fa796ace9d4498fee54eb8a026e23f8bda

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
