FROM public.ecr.aws/lambda/python:3.15@sha256:adcb1e39830bd24c19d1ddff38928c02839a551e987d155a2e4da43f21360163

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
