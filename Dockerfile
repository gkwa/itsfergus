FROM public.ecr.aws/lambda/python:3.13@sha256:9d4aec242ea39eb7543aafd97871b6a6562ac230cb25da665c8ff9477281701b

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
