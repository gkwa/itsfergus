FROM public.ecr.aws/lambda/python:3.13@sha256:5cfa74881949173a2871d4b8be62693ba0ac2577ea80e51ca118e5e8eca10960

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
