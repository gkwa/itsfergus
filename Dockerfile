FROM public.ecr.aws/lambda/python:3.13@sha256:870406044a82745b4ddba6ae07e3f39a300650236205bddf2f7be9b9fd528d07

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
