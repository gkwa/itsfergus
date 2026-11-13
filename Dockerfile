FROM public.ecr.aws/lambda/python:3.15@sha256:4fbad1f61c74026f42a6b071ce3e103f2b419b8f73e724ef622cacc85e9f67d6

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
