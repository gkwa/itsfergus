FROM public.ecr.aws/lambda/python:3.14@sha256:c0b6ca729b20326b694659e828290acba68e29437592aadff306e494409b72e1

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
