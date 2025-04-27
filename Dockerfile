FROM public.ecr.aws/lambda/python:3.13@sha256:6c947cabed694878086e71bf56cb3733a977cc6f2e1290198d20f41e8be6d838

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
