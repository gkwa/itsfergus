FROM public.ecr.aws/lambda/python:3.14@sha256:c747507eb32b1a643568441d24b5c7fb27935df48b50467791f34a4c09ca171e

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
