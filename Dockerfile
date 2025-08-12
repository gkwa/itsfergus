FROM public.ecr.aws/lambda/python:3.13@sha256:d9242ebadd9ff83347c6be6361ab3a215b2b1c60170a595ba01991e5ca9ceafc

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
