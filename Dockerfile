FROM public.ecr.aws/lambda/python:3.13@sha256:72fab5846cbc8dae73dbdce1cf2eac8fc61ebba662ca07b004adc9d930716bdd

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
