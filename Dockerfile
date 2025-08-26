FROM public.ecr.aws/lambda/python:3.13@sha256:8a3090d726fa91c57ebf05428e834fab76ce6a5fb8df72fdcc58941fb3307340

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
