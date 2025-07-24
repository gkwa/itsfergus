FROM public.ecr.aws/lambda/python:3.13@sha256:1ac5e86f8710d32ce980a00ff051fff764da461e65985da27d744aff35dce60d

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
