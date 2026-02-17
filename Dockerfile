FROM public.ecr.aws/lambda/python:3.14@sha256:d6d3011886d24d962c86f8b7b010ab1b3dfab18b4cb12a04070158edeedb984b

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
