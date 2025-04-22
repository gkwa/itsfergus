FROM public.ecr.aws/lambda/python:3.13@sha256:c36ed8595ecf9a9e92fea72540fb04522924a9eda83649c5ed4c19c6f17add2d

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
