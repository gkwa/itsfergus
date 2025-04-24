FROM public.ecr.aws/lambda/python:3.13@sha256:7e593f64f2002592feb70d7948015abe205845f1d94a4bcd6fb45d2c928275aa

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
