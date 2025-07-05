FROM public.ecr.aws/lambda/python:3.13@sha256:3beebdcfa0c90debc5cc7446ab6dcad785d2e68e4c5ed015c935ab6a03d93e16

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
