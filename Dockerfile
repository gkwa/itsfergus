FROM public.ecr.aws/lambda/python:3.14@sha256:963f06840fe3f71d4d1617a189a7d9c754ed0ba9094f5f6d1ac938a7dab49522

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
