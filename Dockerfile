FROM public.ecr.aws/lambda/python:3.13@sha256:f1d12a26df4a2be7210c33cb7c35dff7dba22a4fc8e1f6845bacf99b4641b60b

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
