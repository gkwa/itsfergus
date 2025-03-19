FROM public.ecr.aws/lambda/python:3.13@sha256:9c074a1eb11b6c44050ea8f86fbd7a20f8c623ea34dd69c35798bdfd98de4041

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
