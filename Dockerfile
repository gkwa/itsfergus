FROM public.ecr.aws/lambda/python:3.13@sha256:991ef99493003ec21686302b8beb0d0e995c5ad5eb219684194fd961d4a321ff

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
