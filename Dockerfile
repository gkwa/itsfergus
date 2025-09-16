FROM public.ecr.aws/lambda/python:3.13@sha256:5d94179d6515bbd3c63e0e31cfe45fff1c876ae74958051e36a177d693713886

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
