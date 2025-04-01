FROM public.ecr.aws/lambda/python:3.13@sha256:c99d19619deec5348812dfe5f34a896996f8577d25e2c60ab0cd81e74222c019

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
