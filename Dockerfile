FROM public.ecr.aws/lambda/python:3.13@sha256:1ef8416e080a80b98b8ca15e6d16cd952d04a4cfd82ad749f009e2c23cbda59a

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
