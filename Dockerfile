FROM public.ecr.aws/lambda/python:3.13@sha256:0be56163443c6ccd210570ad35f79778c408c99afc505de8a7955fd7bf60a9ec

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
