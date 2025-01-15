FROM public.ecr.aws/lambda/python:3.13@sha256:d8a6ad47f32e30fbaaec5cca3cff3140f5949e9b50515fc995f173a9f199fc84

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
