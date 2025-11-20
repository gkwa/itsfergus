FROM public.ecr.aws/lambda/python:3.14@sha256:b4e4c8ab1cfafa8d6d3d1796cd9220a78b061608b60b56092b524064996695d9

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
