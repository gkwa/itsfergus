FROM public.ecr.aws/lambda/python:3.13@sha256:b284eec00b54078fcfa336fae47583fcf8a9fc1701e6832a2cd017ab55f0f152

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
