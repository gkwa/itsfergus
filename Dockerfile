FROM public.ecr.aws/lambda/python:3.13@sha256:48b939526d7b50916fb4f8351c8dd17a388958e8a99f78bf1827f7ec5e90778e

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
