FROM public.ecr.aws/lambda/python:3.13@sha256:6163db246a3595eaa5f2acf88525aefa3837fa54c6c105a3b10d18e7183b2d2b

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
