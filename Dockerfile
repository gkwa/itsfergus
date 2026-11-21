FROM public.ecr.aws/lambda/python:3.15@sha256:9ccea91653eed7f28f53c6653ad8398b2096d63b4e8f57b128af1c137d7c2718

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
