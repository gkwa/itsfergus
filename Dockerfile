FROM public.ecr.aws/lambda/python:3.15@sha256:bb3d0bc241a09dfdb04f6e337953e07236f6920cb52eaf5cf45de4884db34d54

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
