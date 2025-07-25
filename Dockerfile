FROM public.ecr.aws/lambda/python:3.13@sha256:9dd69f0e7da770fcb41f9ee23c472065015100b2513241c3d5ce691adf290e7c

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
