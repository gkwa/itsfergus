FROM public.ecr.aws/lambda/python:3.14@sha256:6e1efca9d6ae76718f37b2fb94b935ba0c419a95729901197a08fe305d366f09

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
