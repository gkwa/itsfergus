FROM public.ecr.aws/lambda/python:3.14@sha256:aa3270ff4d915c683970ffce7d764d30cefe13cb53d27c0372233fdb231c3d91

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
