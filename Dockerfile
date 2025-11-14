FROM public.ecr.aws/lambda/python:3.14@sha256:e78bf9180c4f3356cd7a1a056e6a8a841196ccbad1cb8090c2a9e0a6ad6bfd1c

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
