FROM public.ecr.aws/lambda/python:3.13@sha256:b00aa45f85d5b940c3409ac6ea972f4f54002762af89a06d8d8a81b6293175e6

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
