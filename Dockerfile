FROM public.ecr.aws/lambda/python:3.14@sha256:9337593a0777142e10c688b0d8daa3d6dbcaf4c94d7936f77aa09b7c19c61b1e

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
