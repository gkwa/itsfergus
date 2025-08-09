FROM public.ecr.aws/lambda/python:3.13@sha256:c4d5b275900d7a9bb5f243c110f5ead2fa6b838a8b37390a8ce8a88a08ccbc19

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
