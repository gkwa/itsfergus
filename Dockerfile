FROM public.ecr.aws/lambda/python:3.15@sha256:0583e417955cc5c93f55e9e3da8d61137a17fb3993a4c983972499168df642e9

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
