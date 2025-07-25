FROM public.ecr.aws/lambda/python:3.13@sha256:f68ce47a71abbee3aeccfbac6c99e2322d0424d43ab72ff50c78c8e50f5005b0

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
