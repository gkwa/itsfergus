FROM public.ecr.aws/lambda/python:3.13@sha256:bcc605289b87c378574158309767bb8ed809f382fca1421fb8d019afb2d9fe20

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
