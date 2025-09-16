FROM public.ecr.aws/lambda/python:3.13@sha256:8f4ae3e3cd7ea0d615bbd40fe1f04467cb8b9e1ae5402a44f204ac366d3e2747

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
