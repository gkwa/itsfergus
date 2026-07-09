FROM public.ecr.aws/lambda/python:3.15@sha256:97440f9666ed5cf3c20eef8ab3bcb7933f477b515b6a90295b3f958e5cd98333

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
