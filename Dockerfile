FROM public.ecr.aws/lambda/python:3.15@sha256:0a5664e8fb08b5d1fc1a532022bfa2cb52571b374c985ff2f140bf7859366e6e

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
