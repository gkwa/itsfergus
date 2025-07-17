FROM public.ecr.aws/lambda/python:3.13@sha256:538c85144c29ade7408aa57d6113b2a092ea0447a9610aa927df263427bde0e6

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
