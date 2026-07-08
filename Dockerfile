FROM public.ecr.aws/lambda/python:3.15@sha256:abd64eb69d67c8dbb0d80655acea165ade96763b1ef79b02dfea4e130982e1eb

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
