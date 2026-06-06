FROM public.ecr.aws/lambda/python:3.14@sha256:d17853eca0e20cebd676ea47b206fe3aa8238b210dede3ccb324cc510b5aa43d

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
