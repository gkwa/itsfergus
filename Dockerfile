FROM public.ecr.aws/lambda/python:3.14@sha256:c1106320e01e5509365f787e2e852a23fbb4a2d2a2943ff4152c1aaf73cc95d7

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
