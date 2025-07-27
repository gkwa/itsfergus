FROM public.ecr.aws/lambda/python:3.13@sha256:7575f3cb5456f85a62a1b100e2c0253a530ba3544c2516d074652b16b164ba01

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
