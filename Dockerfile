FROM public.ecr.aws/lambda/python:3.13@sha256:07cde95217131792bf6389b355282c83a40a4fac4f39b2730367ae78c12cac9a

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
