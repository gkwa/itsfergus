FROM public.ecr.aws/lambda/python:3.14@sha256:f984f75973b81d141e98cd8bfdae9b1e5654d418f137cdf4c0f9de3687acd559

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
