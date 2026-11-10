FROM public.ecr.aws/lambda/python:3.15@sha256:d22fca192b96f04837c32249995011c074c6f568c7d0fd2e0de5549fdb3a755f

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
