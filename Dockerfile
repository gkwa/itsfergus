FROM public.ecr.aws/lambda/python:3.13@sha256:81c32aad893a71a1e7e64db7c1640acb57b380fda71632a1d3db7749d335b187

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
