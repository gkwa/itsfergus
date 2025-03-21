FROM public.ecr.aws/lambda/python:3.13@sha256:83b6a558d5a6cdc894ef0b478a6ca3ad67d5b0265a8c77b89bf284e05e748b3a

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
