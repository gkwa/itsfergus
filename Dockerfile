FROM public.ecr.aws/lambda/python:3.14@sha256:f731cfb927878a8ce493f1a3caf504a59692a94bd6555d908d3e6f2a300ec0eb

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
