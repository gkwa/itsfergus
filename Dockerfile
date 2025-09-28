FROM public.ecr.aws/lambda/python:3.13@sha256:5e5ab882cad1af59ffdbaede2ad6f68663e8f5ca24a4811a5e0ef97b559612ac

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
