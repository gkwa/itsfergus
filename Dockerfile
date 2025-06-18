FROM public.ecr.aws/lambda/python:3.13@sha256:32b964af182550de18fd48ca7a4502f648c7198f4a7c163a4b101be7b05bb9f4

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
