FROM public.ecr.aws/lambda/python:3.13@sha256:8c681db5483cc3817257682dd3a4d2026132cac6c9f7f0cd70a1373e98be3ecf

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
