FROM public.ecr.aws/lambda/python:3.13@sha256:be7e9da10ae4d976e7116e1b5461712053f023b87f8564b50c660dc4f4458e7b

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
