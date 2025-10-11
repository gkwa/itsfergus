FROM public.ecr.aws/lambda/python:3.13@sha256:eb6f5fd5d8904084bc7d7d60b5714a0d3d0a751e570f7ba9869de9e46cf5ec68

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
