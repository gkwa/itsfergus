FROM public.ecr.aws/lambda/python:3.15@sha256:2e1e0a54c13f5292c29c0f72d8efe769f7179e171f50bf3a4e054cc52bfdaaab

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
