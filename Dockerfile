FROM public.ecr.aws/lambda/python:3.13@sha256:9ac68a257b44bb04f86c00d2103d51f8d488fb0a037a977a4632eaf53a02c5a2

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
