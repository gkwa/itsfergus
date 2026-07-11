FROM public.ecr.aws/lambda/python:3.15@sha256:9a4b43cd5797d88634705d4f7094289365d5c9b565b08ee78f9f333c276a3f3f

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
