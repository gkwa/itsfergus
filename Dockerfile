FROM public.ecr.aws/lambda/python:3.14@sha256:2918c64da6fefcd676fa9bf7fb95586c10e222858b8934dc6ecc743ff03e02a8

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
