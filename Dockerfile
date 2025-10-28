FROM public.ecr.aws/lambda/python:3.13@sha256:0b267232e8fa99b53c7d02c62f833bd84a71173c597553e39da87b24303c2d2d

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
