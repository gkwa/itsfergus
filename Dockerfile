FROM public.ecr.aws/lambda/python:3.15@sha256:7260f131a3fcff81b6164b21f0e0db63fd2f245543c8a05fa3f5212c1ecf52b2

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
