FROM public.ecr.aws/lambda/python:3.13@sha256:90256ba0b2d70eb29295cbfaddeab391b65214fe63fb20d4b8b6c25e22711629

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
