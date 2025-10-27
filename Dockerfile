FROM public.ecr.aws/lambda/python:3.13@sha256:1e784863b7d21e1ba661e397520508598d000b9999bcc08d4c2f12eb52e74f95

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
