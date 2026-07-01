FROM public.ecr.aws/lambda/python:3.14@sha256:ef1ab8dc19ab97da57b98fd77035a945587270acf2a6eb2853f7ec9ad7ea6f14

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
