FROM public.ecr.aws/lambda/python:3.15@sha256:06fd9a9166605561240a6565f016d9b25abe6babdb207d0df15532a7ef2f4073

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
