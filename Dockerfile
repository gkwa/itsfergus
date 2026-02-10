FROM public.ecr.aws/lambda/python:3.14@sha256:e0a27d03fe59afe4374d09864608b47f8e0b84dec061b2f5e95ba96b38cb42c3

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
