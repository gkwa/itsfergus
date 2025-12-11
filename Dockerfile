FROM public.ecr.aws/lambda/python:3.14@sha256:3b5df95295fa1247bf551fe7c4fda725cfb4f453cafa9bad1066c3484cb310c4

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
