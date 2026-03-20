FROM public.ecr.aws/lambda/python:3.14@sha256:e3ea6ddaab2c71f897ee2aa920e1fe2f86f73ee4523b86ba152b51ac9a5b30c7

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
