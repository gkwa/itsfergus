FROM public.ecr.aws/lambda/python:3.14@sha256:10caad75cac688d8a8773f2ea2ec0aa6a3940a3d7d5716b8a3ccb5c2bc636c88

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
