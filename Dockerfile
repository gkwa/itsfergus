FROM public.ecr.aws/lambda/python:3.13@sha256:4a4ca5ff3639ba963e218fa66417fbcdfa19a03fd71c5011acf4e4eed542392e

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
