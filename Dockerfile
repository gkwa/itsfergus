FROM public.ecr.aws/lambda/python:3.14@sha256:dfdb25eae81491aff260df76b8d3c05815708b9ede0fdb76921a7fe4b4ab19a1

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
