FROM public.ecr.aws/lambda/python:3.13@sha256:ec04c8aaded0203078fc7e3604d8a9acc1b756b2e97a9d81cdbd70f2bad02676

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
