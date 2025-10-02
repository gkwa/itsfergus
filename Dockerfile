FROM public.ecr.aws/lambda/python:3.13@sha256:bb271cdf756c699fd653bfbd26b1dbb8de031d119d1c109ac5668647206b1db4

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
