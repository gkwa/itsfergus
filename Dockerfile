FROM public.ecr.aws/lambda/python:3.14@sha256:5845a5c27c91e3fd58f59dba3958b3877a9db757d5be37e297d4cc39a9715431

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
