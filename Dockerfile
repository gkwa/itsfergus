FROM public.ecr.aws/lambda/python:3.15@sha256:b824882f15c6e74f9d21bfe779b28d08688b596699235cd529a79e1d7fd4d121

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
