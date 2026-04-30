FROM public.ecr.aws/lambda/python:3.14@sha256:f466e865e20651100874bfa15d246f0b80569930e7835c62e251b998a154ba45

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
