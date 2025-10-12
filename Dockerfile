FROM public.ecr.aws/lambda/python:3.13@sha256:2b00c9883624cadf45e7daf1953a7c4ef8bcd56238847c670d0c2aedd9926f5b

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
