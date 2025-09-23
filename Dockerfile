FROM public.ecr.aws/lambda/python:3.13@sha256:d8aaa1ac9827c257e5b3fe8f6df861bbcd0984348a55c33caf609a73fa7e1f81

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
