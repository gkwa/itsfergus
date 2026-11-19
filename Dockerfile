FROM public.ecr.aws/lambda/python:3.15@sha256:15a14c98cf96219684c89d863826191c86c383220681a14f15700e0f2ad53aa0

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
