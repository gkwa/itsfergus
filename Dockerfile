FROM public.ecr.aws/lambda/python:3.13@sha256:b7e4d10db1a0ad8965f04ecec4c0db2f5992cb2bd1ae28d2cd95f1583399f361

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
