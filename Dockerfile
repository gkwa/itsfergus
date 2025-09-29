FROM public.ecr.aws/lambda/python:3.13@sha256:36a328e758a3bceae2e5989f1253cf564d680c3a492c27e0c3f140ef935a2938

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
