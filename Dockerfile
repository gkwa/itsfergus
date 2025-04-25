FROM public.ecr.aws/lambda/python:3.13@sha256:664ea075058e8c7476f1e340830eca71eaa8bf5fd1cc7e3f048a6f51d9ba4740

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
