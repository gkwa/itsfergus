FROM public.ecr.aws/lambda/python:3.14@sha256:bbc7bd11f3f550dc81087effa0a8f1d3498a329e148f11052ac37d2c3574f366

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
