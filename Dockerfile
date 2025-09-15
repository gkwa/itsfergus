FROM public.ecr.aws/lambda/python:3.13@sha256:95d5a7a774dc3a6955a86ab0e66c60e4d1ff133620446fbf2881f25911ab8671

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
