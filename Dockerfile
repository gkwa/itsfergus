FROM public.ecr.aws/lambda/python:3.13@sha256:cb8cff71bde02f4057f4884ffcdba61e8f6cebce0db7cb293b6cb03a16e5d016

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
