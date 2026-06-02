FROM public.ecr.aws/lambda/python:3.14@sha256:df083edbeb5220cc6773bb00f4ad0486bffb0a318e1cde6e0e617d7cfd6aa9c0

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
