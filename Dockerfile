FROM public.ecr.aws/lambda/python:3.13@sha256:b96b81c6f47c76929dade4db774d517004b81818d6ef163179b0c3657cec190c

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
