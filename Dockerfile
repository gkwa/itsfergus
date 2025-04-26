FROM public.ecr.aws/lambda/python:3.13@sha256:622babc5888a2fd83927109ee38fedd5dc8b08bb5141d421bfe7fb8121804b22

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
