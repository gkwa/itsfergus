FROM public.ecr.aws/lambda/python:3.15@sha256:ef619d92985884a2e2fbb4e7638c22831721bae70dc65f2e626f6b77e981e29f

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
