FROM public.ecr.aws/lambda/python:3.14@sha256:1da4bc3e2470b71faefb413524cfc17ed630226ba5f3639a53916ffb118c35cc

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
