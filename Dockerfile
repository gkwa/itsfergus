FROM public.ecr.aws/lambda/python:3.13@sha256:7078abe96f3137e8cd19d04566c30c2c879a30856d0b7f70121ab6ce1e8e5a9e

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
