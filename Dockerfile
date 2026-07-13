FROM public.ecr.aws/lambda/python:3.15@sha256:3b21729bf66c13f1d7b79f614c0667338e0daf4774d29b19340372f6ac1c3361

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
