FROM public.ecr.aws/lambda/python:3.13@sha256:9b49ea125103e0b0cfa17aab9121e5ebd1588953426d15594fedd5ae03e05cf8

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
