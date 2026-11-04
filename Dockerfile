FROM public.ecr.aws/lambda/python:3.15@sha256:85489aeeb81b5f3c8e017a19d2170db55873262c4c52cfa40cc1f0c16a74d549

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
