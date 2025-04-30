FROM public.ecr.aws/lambda/python:3.13@sha256:e77e31082d776831a98f2fb5d8179e3c7ef06f77f830a725b57a34fbff0bd78b

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
