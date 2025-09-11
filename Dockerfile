FROM public.ecr.aws/lambda/python:3.13@sha256:334fe476c48904cb360e90caa11ef8e9cbbbed2c06bb8e4602ea67f6b98d0172

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
