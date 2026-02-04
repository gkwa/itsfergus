FROM public.ecr.aws/lambda/python:3.14@sha256:a5c04460150e6534196db7facce131a4c2d672aba621fbb93dd0bc15276fa2a6

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
