FROM public.ecr.aws/lambda/python:3.14@sha256:05479790091b927ab96e5c14134323fcdfaa91f2cd80d6ef94fef4499e414b64

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
