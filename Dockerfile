FROM public.ecr.aws/lambda/python:3.14@sha256:8dfd87cb953250d69493a74e2f27dbc83543acb43c7f2f5ba3be42e0ee871bea

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
