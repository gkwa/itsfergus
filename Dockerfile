FROM public.ecr.aws/lambda/python:3.13@sha256:2e8923ee4891f8532c0775dfb5137c6245939cae1381fe7679833659290cb7ee

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
