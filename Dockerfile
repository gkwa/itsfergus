FROM public.ecr.aws/lambda/python:3.13@sha256:ccf98fceefaf43d0cd8f2d3871a60aa23a22a1b5e2831e2c5d44d83e796b6762

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
