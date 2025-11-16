FROM public.ecr.aws/lambda/python:3.14@sha256:5649deff7bfa38a3a341d25371c37c9e16f1b2d37f47ebf0a29c13692413424a

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
