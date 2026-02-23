FROM public.ecr.aws/lambda/python:3.14@sha256:0fb9142e8f604caeb32ba90693f424e53241d535145f66091a0a40baec086e12

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
