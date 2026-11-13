FROM public.ecr.aws/lambda/python:3.15@sha256:769963effb5ee78f6d705754f2b88e82b84156a849c44f6c38a1632a9a14d4d3

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
