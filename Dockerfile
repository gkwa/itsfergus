FROM public.ecr.aws/lambda/python:3.13@sha256:487030d9b234cd2e104b7cc6d330143c4ff9c20f32674b39949576040dc3f7cc

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
