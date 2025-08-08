FROM public.ecr.aws/lambda/python:3.13@sha256:bd1e4faff665ed6de54c14ca917b32e40c3a81f98917b216396eef460011ecc4

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
