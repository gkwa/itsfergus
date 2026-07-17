FROM public.ecr.aws/lambda/python:3.15@sha256:57ed11ba1e33fe2dd1e55e95e0a478c001df8f784f90c5eff482d340c4ed2239

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
