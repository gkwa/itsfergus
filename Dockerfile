FROM public.ecr.aws/lambda/python:3.14@sha256:dedae37809c4d030fe231acef78867776174d09749839762994e91c0d47b4520

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
