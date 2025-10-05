FROM public.ecr.aws/lambda/python:3.13@sha256:bd53508accbaeb0977c5c358b772cbc088a3b324523e43f191f2ddb784ea544d

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
