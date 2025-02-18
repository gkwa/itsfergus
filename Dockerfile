FROM public.ecr.aws/lambda/python:3.13@sha256:5e7e09c5bf735a8e824511117bb0e9f335b778ac2e17a07161ee1542509b98f4

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
