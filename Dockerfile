FROM public.ecr.aws/lambda/python:3.13@sha256:aad0083d77f608105930fc34d0dbde2e8775e077eeb344697a5e9b3ebf05d58e

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
