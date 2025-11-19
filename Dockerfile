FROM public.ecr.aws/lambda/python:3.14@sha256:c0893fd03bf7b4f4e7bec13fe82a6c9757842eb826ad67cfea524a1b55f7c0eb

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
