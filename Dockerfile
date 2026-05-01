FROM public.ecr.aws/lambda/python:3.14@sha256:3d9271bf6a7ed937a3c9e122a721385ee521bfc6c2491a545ab3896b062feae0

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
