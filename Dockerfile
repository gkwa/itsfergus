FROM public.ecr.aws/lambda/python:3.14@sha256:4f0630cebd1e09ab6d59b4fdf35173f17efd51a7a3c7255d4f5d9f3bee802958

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
