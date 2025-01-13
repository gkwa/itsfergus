FROM public.ecr.aws/lambda/python:3.13@sha256:eaa239809de172191ab70daebf5b32650155e706310761e3b63bbac351f91ef8

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
