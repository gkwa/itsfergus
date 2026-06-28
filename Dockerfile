FROM public.ecr.aws/lambda/python:3.14@sha256:73ab389bb3a63c3dcea1fb0674026a191b758963bd48f674f66e4ab31545e3b2

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
