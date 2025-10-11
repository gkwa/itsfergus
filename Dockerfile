FROM public.ecr.aws/lambda/python:3.13@sha256:f23c10d749cad3381e830b2174fa728b7a8e479befd1207c1eb7b1c4b40db57e

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
