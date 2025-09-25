FROM public.ecr.aws/lambda/python:3.13@sha256:64d0e231c2d432499f304b83d46d414ce1d08507b084583f38fb41457c2e3ef1

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
