FROM public.ecr.aws/lambda/python:3.14@sha256:e0ceca2f27a3624da165c32696c81e76f27ed5d5495aed87dfa91dab1b24a8df

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
