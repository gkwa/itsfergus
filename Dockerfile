FROM public.ecr.aws/lambda/python:3.13@sha256:0c0b9b080ae21cbe669134cbacd59cbeb0dfce797f59c24bd403b145c8bd9a5a

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
