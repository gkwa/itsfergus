FROM public.ecr.aws/lambda/python:3.14@sha256:ce489343899c464ce81a61e06f4602c1e9bec97e92ecdc0b12edee3591ae9c47

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
