FROM public.ecr.aws/lambda/python:3.13@sha256:05c206daab832f91f499df2873bbc09e5f87e553830afaf2a7848bedad968345

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
