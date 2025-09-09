FROM public.ecr.aws/lambda/python:3.13@sha256:118389f4e1ef137a3c9194d417d509b5d326cbab29d2ccac826c01d8ec32f9e6

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
