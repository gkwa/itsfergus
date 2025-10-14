FROM public.ecr.aws/lambda/python:3.13@sha256:6044eeff8e9c2fe22aa8836f58a72a1561cb88e2236f64869154f2b76917e4d1

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
