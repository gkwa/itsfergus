FROM public.ecr.aws/lambda/python:3.13@sha256:cf4519ad761cba994c2f8508ebce492055dc4a64fea4452412eafe4f24c2028f

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
