FROM public.ecr.aws/lambda/python:3.14@sha256:5e56694284a3c3227224466598697cda3d71fcd97ea2fc5a4065ffe20a6245db

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
