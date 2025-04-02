FROM public.ecr.aws/lambda/python:3.13@sha256:110fb4a656b4c91ade153d356ecf2977d030366a2e6be2f4659b8e678ec3c946

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
