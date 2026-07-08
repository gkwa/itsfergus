FROM public.ecr.aws/lambda/python:3.15@sha256:f6aa405dd25ac6bd6a0720987f245e3de885c4dd287558fc118d897e7c189abd

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
