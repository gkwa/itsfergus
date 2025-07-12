FROM public.ecr.aws/lambda/python:3.13@sha256:5e1f7986477b164e9c93268a4281c82cb79e91db3d003f9f8ecbe003261a750b

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
