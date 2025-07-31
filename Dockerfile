FROM public.ecr.aws/lambda/python:3.13@sha256:1594dfdf3fe18b722d70f7d9a0ba069be318d5f757d7d6852ea95cd9f81e1238

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
