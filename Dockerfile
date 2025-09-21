FROM public.ecr.aws/lambda/python:3.13@sha256:a94292e214a901ccae682a852378c31c1a3945ad4dbc4ed7cc91291abd6f4607

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
