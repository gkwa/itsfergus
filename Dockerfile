FROM public.ecr.aws/lambda/python:3.14@sha256:600aabf76ac192080ae08d5ca628f452a6aca6467d5ced81d3fc7e4e1768ac11

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
