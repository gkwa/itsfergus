FROM public.ecr.aws/lambda/python:3.14@sha256:bc49d8c94c9c3406549a5919901afc3126a23b4b03ecdcc379ba50b06ae4366e

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
