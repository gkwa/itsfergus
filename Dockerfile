FROM public.ecr.aws/lambda/python:3.13@sha256:b3877745ca4807674b4d6f6444c0cf20ab0b5a311a2fc2ad527f6f684075384c

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
