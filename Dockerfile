FROM public.ecr.aws/lambda/python:3.14@sha256:58391ecb04f6f5e090e1cfe4601becf57d21a07ffccce67ac1876dc6404291e5

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
