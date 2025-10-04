FROM public.ecr.aws/lambda/python:3.13@sha256:3d3dd33b9dc91232af3736475fb593f9e3e51efe614730f7f7658d70259889f2

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
