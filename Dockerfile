FROM public.ecr.aws/lambda/python:3.14@sha256:48086128720ae47bb85d40a1740d9a365ebb178e10a173a5bbfd3d0b8301a6f7

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
