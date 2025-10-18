FROM public.ecr.aws/lambda/python:3.13@sha256:8021a863015905d63815879c9418c49188b5705b8f7665fc3f3132e1ccee17ba

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
