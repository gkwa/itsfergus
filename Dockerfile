FROM public.ecr.aws/lambda/python:3.14@sha256:c1ef5e199d351ed24cc5f24a949099ec2a28cffd589320f62f7ddc35a8ea878a

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
