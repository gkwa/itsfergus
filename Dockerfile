FROM public.ecr.aws/lambda/python:3.13@sha256:4213af37c60936b7e9ba5f4e3d5c99eda11f05de54cdd3a35c2b12e0dba5090a

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
