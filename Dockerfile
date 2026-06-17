FROM public.ecr.aws/lambda/python:3.14@sha256:cc5d852ba22874d237df9cd94ff7c7f35774f4af32a93f660b037b5c80e73b4d

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
