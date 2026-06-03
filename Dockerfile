FROM public.ecr.aws/lambda/python:3.14@sha256:da69ac7be7eec315ae30daefd50e35a56ec3a5faf50ac5f33cb216d5f5a1274c

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
