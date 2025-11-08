FROM public.ecr.aws/lambda/python:3.14@sha256:1fa4a196bb91de3ed3a4cc14437e8eaf27f600d7b1182cd4447897fbc9f5dd53

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
