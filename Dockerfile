FROM public.ecr.aws/lambda/python:3.13@sha256:614df4176ae2fdbc33685eca1c11453a254c0b4eaaf9227ec431cc0400ee16c9

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
