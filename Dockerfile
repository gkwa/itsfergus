FROM public.ecr.aws/lambda/python:3.13@sha256:53d3d77883792d5e3264215bf3ae4d1554736903f388fa401da9510648d24dd1

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
