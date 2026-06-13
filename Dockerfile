FROM public.ecr.aws/lambda/python:3.14@sha256:f0ab35ef89476c81910c472928ef029822e194a2b62e1c9428928f3e353313fe

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
