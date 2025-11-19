FROM public.ecr.aws/lambda/python:3.14@sha256:1d7f3abf75cf07924b69cab3191c9c389b5c0787353e26b606495a5243b3733e

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
