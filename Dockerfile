FROM public.ecr.aws/lambda/python:3.13@sha256:cc54bd641120fb2fbe88e227421dad066a5140482b151e165378657ac3cce32a

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
