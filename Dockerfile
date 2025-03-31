FROM public.ecr.aws/lambda/python:3.13@sha256:3439857092837402879d7892d2ce7cb2290c7ab29644db9ea51cf1cf20d95be3

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
