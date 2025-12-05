FROM public.ecr.aws/lambda/python:3.14@sha256:6ac4753bf6baf5a2df0cde8a6f6e9a351742cfdadb7664ca51f68558412bb716

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
