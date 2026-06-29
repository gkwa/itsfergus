FROM public.ecr.aws/lambda/python:3.14@sha256:2f729c96b94e64566828eb692ee0cd3c0718c0f7d2c72c6fdc62e69c776ca918

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
