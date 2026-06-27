FROM public.ecr.aws/lambda/python:3.14@sha256:0646c5362d938f63fcb2ca83a32f4ff95cc06abb29cb9be74da696a6d5aab701

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
