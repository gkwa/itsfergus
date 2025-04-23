FROM public.ecr.aws/lambda/python:3.13@sha256:d2fac9b3d778318042de4e250b5bc294dabdbbfe6ab227bd0d2a7ae59f2dc3b2

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
