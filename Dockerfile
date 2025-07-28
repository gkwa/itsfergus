FROM public.ecr.aws/lambda/python:3.13@sha256:9463ced03279a00e131c0587c2d4b56a9f292f812409b6b5a2ed590af8cbb8eb

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
