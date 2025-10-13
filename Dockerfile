FROM public.ecr.aws/lambda/python:3.13@sha256:2d7fa165a150ac899101a61b0fbe1406929a587a13e5a7857a8a9bb0e2ce0782

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
