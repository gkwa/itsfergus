FROM public.ecr.aws/lambda/python:3.15@sha256:2c60e9e426325d60a5767df4c1e84aba07801c6490f314df1475c6438ffc7628

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
