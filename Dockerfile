FROM public.ecr.aws/lambda/python:3.13@sha256:024134948d33d94255835a2b4c3a718781461e018de4ba87159d35b49eb6cec0

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
