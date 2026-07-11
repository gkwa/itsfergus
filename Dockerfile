FROM public.ecr.aws/lambda/python:3.15@sha256:c26b664cdf5f0e504ef3bc1ae376d77a5b96ab1f31965338bb6804b4795cfc9b

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
