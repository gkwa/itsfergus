FROM public.ecr.aws/lambda/python:3.13@sha256:189046ab773d9246d47abeb8562d924e39fa6e829c823aefa2dc0aaa311e2565

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
