FROM public.ecr.aws/lambda/python:3.15@sha256:1e59ea8496c9d22a35c851999d748152317fc8a3d8f7154f829e20f18f005aca

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
