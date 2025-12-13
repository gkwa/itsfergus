FROM public.ecr.aws/lambda/python:3.14@sha256:9759d82f811c855e30367d2709b82958f7c54cc30534b8e0d2c8ef51943fd366

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
