FROM public.ecr.aws/lambda/python:3.14@sha256:b0b4511b419fa9b4823562543f3620dfc36a690e9067ff69ad846fb3b218838a

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
