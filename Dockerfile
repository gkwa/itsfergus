FROM public.ecr.aws/lambda/python:3.13@sha256:de368792d89827e950d750704b6b5c4505d5462b033881d2916997781c9b241d

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
