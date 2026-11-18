FROM public.ecr.aws/lambda/python:3.15@sha256:14e5711c512caa87a1cb28eba1c4381d964ed1faf7206f16ed05c7ef9692cac4

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
