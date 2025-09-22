FROM public.ecr.aws/lambda/python:3.13@sha256:59f2e865cbc224b18d35a393690a7e25c1e792c3fccb4cc924bf545f9470b4eb

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
