FROM public.ecr.aws/lambda/python:3.15@sha256:a843a538de7d2772d637644d129db4820c27e8d9a5083f098349d77541fd70a5

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
