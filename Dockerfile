FROM public.ecr.aws/lambda/python:3.13@sha256:281f190580e7fdd627a06e2c19af83a071b08a95a66d80cf04ddeeb884b825cd

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
