FROM public.ecr.aws/lambda/python:3.14@sha256:0142b38621f5c907bbc4581cd92a3aa6813d4972f99f112cacd87bf6f9e99025

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
