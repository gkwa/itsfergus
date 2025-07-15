FROM public.ecr.aws/lambda/python:3.13@sha256:8a7e192732832465cb613ab8bbcc8c7b8c926f781947cae2963bc97db507c2de

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
