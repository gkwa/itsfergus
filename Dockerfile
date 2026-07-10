FROM public.ecr.aws/lambda/python:3.15@sha256:a0d1d52dade441c23c1745248e7b9d39f1d3f6e2b09d458ad95f25fecdc198d9

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
