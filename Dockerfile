FROM public.ecr.aws/lambda/python:3.14@sha256:381311002ca61cc8e4b5489caa93753ed61fe567f96eb97fce039e48d5a825e7

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
