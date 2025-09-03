FROM public.ecr.aws/lambda/python:3.13@sha256:7a4dea91497f6551b88778be4c73ca2035db509a4aa4068c6317376308a7a6b2

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
