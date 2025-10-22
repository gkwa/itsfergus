FROM public.ecr.aws/lambda/python:3.13@sha256:899e4329c456af44449428732f19705bfb4f784dac9367fcaed010f079972841

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
