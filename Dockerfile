FROM public.ecr.aws/lambda/python:3.14@sha256:d802737599dbdd789201e3c9a0d18a23fc233091a17b4c7653e0ae5f07a2d660

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
