FROM public.ecr.aws/lambda/python:3.13@sha256:6b96c91a2fbea04d46a94ca308c226c3098eb52c99ab3db5ad5bfe611bee30d8

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
