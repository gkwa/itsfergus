FROM public.ecr.aws/lambda/python:3.15@sha256:b6324a1bb8690b1a25cd312e1c2fbd79d5d505c11278e0ef02b6e6a044f55eb2

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
