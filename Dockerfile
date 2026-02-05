FROM public.ecr.aws/lambda/python:3.14@sha256:ccc6742bfce78616a979a20a1b1fc769366d71b0170308db7cc1c67be552facf

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
