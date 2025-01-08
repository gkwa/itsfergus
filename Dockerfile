FROM public.ecr.aws/lambda/python:3.13@sha256:b55d728b6dbedf77e48ce6c9c634942a0a2df106eccf865377cbd22728d30e2b

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
