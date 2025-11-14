FROM public.ecr.aws/lambda/python:3.14@sha256:252156db0584693baf909c60b3cf3a931bf608e59a2d5baf63aece6f0a0c4d9e

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
