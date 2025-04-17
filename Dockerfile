FROM public.ecr.aws/lambda/python:3.13@sha256:b380eb52feaf36e4b89258e8a202c80db1a94e880cab67266fe875db58c4e580

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
