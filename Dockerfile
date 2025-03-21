FROM public.ecr.aws/lambda/python:3.13@sha256:d30c9efa9487203c998f025b572daa5bc8da96d1913194566cf8c03bfa336800

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
