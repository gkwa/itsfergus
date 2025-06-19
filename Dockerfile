FROM public.ecr.aws/lambda/python:3.13@sha256:01a68895b1eab3e6fe7a37dcc71f65791c353c5c76aed65c6c8cb5977033e575

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
