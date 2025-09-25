FROM public.ecr.aws/lambda/python:3.13@sha256:136a9290e8fbff7f0aa77fef2ad4b044eb88ac8c3f1a98ef0ab6ecdc5ca628b3

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
