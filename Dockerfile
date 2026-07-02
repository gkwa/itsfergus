FROM public.ecr.aws/lambda/python:3.14@sha256:12389272ad28512f684231b35534ef91bad755ffe27e3f1582b5e455d0b449a4

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
