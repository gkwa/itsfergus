FROM public.ecr.aws/lambda/python:3.13@sha256:1262ef9c9d42843ab97bdb7aca8d39a8280d25d0013d5da61b081948845cf00e

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
