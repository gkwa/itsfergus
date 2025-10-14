FROM public.ecr.aws/lambda/python:3.13@sha256:ac4766a9047fed7306ed92aedc567c4b5114cdfee591d3d5e3f0cabd89f0acc6

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
