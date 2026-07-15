FROM public.ecr.aws/lambda/python:3.15@sha256:f029515b81efd196e23bc674803cb274bf69809201c2df5bb1d93d9263b6545f

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
