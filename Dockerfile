FROM public.ecr.aws/lambda/python:3.13@sha256:922f8872e248a97f73a319aaa711827d38e2c9d3c032a2aa26647dfee528ea30

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
