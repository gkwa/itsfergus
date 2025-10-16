FROM public.ecr.aws/lambda/python:3.13@sha256:57703f4203932ab765ea7b306221c8a8f8576d8aec2bdd39d703e8ff56b1a9ba

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
