FROM public.ecr.aws/lambda/python:3.13@sha256:c5e35a293354ee5f4ddd04cd014ce5164d5630bcb027d25a0500941ab3689da9

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
