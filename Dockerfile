FROM public.ecr.aws/lambda/python:3.14@sha256:6b074155d0342e9a8f2cfff8ee513ce56dbe3dc9a8643dad70bdc02d5d281c06

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
