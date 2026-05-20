FROM public.ecr.aws/lambda/python:3.14@sha256:16ec858d547c5cc2debd1e45118a19efc6fdcc0c5ba66422e059f2957f7f1a64

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
