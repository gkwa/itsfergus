FROM public.ecr.aws/lambda/python:3.13@sha256:1512a39bdac0d141114ec3d8f10371b79af088f9ce6026c10a503ba429e806f3

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
