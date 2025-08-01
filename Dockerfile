FROM public.ecr.aws/lambda/python:3.13@sha256:0783db7ef0e824c649f3a913e80482a013aaf2ae09e5644eef43f00bd0fc1d6c

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
