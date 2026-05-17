FROM public.ecr.aws/lambda/python:3.14@sha256:06d626bb457d3e2667b76ee3397718ab0fa1dd48c2a9cc64622a8ba12c948b7d

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
