FROM public.ecr.aws/lambda/python:3.14@sha256:5a5f9e3166218e7e8f105e5d8f8a76b3e313fbe3a93f35a2cbacc10247af4725

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
