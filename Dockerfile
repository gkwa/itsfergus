FROM public.ecr.aws/lambda/python:3.14@sha256:0b6ce71b0c144acd2459881beb5a23e42c716b16dc9315d3e500304170e18cf1

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
