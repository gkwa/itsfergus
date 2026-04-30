FROM public.ecr.aws/lambda/python:3.14@sha256:89e02d949519bd0ce896877c1d90786d700c89cdfe0c4787b46d872dd7f50c58

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
