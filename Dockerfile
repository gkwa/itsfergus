FROM public.ecr.aws/lambda/python:3.13@sha256:ee2e47f80fe49637dac639a6b25130d417fd2e671c02b25dc60e708794b58d50

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
