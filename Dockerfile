FROM public.ecr.aws/lambda/python:3.14@sha256:3dd7355b7d8239d7b4da86460f0ff490d96b3e2a04827ee88fc86c565604fb92

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
