FROM public.ecr.aws/lambda/python:3.14@sha256:531bcef03352b4bfda5968316b25054def018e301102fb0b3fe1a08eceda222f

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
