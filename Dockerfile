FROM public.ecr.aws/lambda/python:3.14@sha256:e0fc399a245e65e1c6e17942f55efabe2b281a50e9a2298763f000835514991f

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
