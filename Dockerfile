FROM public.ecr.aws/lambda/python:3.14@sha256:9f37b63fd556bb87b2d09a67c5169a0938f63b509977ddd5e6445fda650056e7

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
