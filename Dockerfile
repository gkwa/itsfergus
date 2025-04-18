FROM public.ecr.aws/lambda/python:3.13@sha256:954857891232c9d08cf9f34a5f701654a54b73b18bfb43b3de2ddfbdd74a9151

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
