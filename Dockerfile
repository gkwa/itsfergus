FROM public.ecr.aws/lambda/python:3.15@sha256:b6eb3b9193d55f6387d23ee0e604738778f39a967584d5e16d594f48881da785

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
