FROM public.ecr.aws/lambda/python:3.14@sha256:c59ceb09501dc034b235b885a60f405c4165a2b3b5a6fd59475b6fb76d2565bb

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
