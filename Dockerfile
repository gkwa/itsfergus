FROM public.ecr.aws/lambda/python:3.14@sha256:cc9d41aa8a92df019ec1ad9646491f9b032ca8a50c7ec6825cbea6a3bded55cb

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
