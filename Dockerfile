FROM public.ecr.aws/lambda/python:3.13@sha256:7c68808966c4e29533d6847045c83cd3732c7f03630707a9962d95c512bd07f7

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
