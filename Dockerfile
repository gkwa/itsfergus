FROM public.ecr.aws/lambda/python:3.14@sha256:72d0d318f728a551eafedfda2b625180bb8bdace0c2b1f7457f3086415864f33

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
