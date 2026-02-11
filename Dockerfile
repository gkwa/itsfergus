FROM public.ecr.aws/lambda/python:3.14@sha256:5f5771323f57ad96e086b7cdc9a52d20d66d202a8ee06ee1225601015f7b7b7b

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
