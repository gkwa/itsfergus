FROM public.ecr.aws/lambda/python:3.14@sha256:df9839fefb55192be58cf8b30c0c00b70e3918bad1ef3076f068116ea58e6a0d

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
