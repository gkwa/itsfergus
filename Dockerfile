FROM public.ecr.aws/lambda/python:3.14@sha256:deddbc20e4e7ecc1eae24f73519c3eda94fc1d786f03d35580c43e337b93508f

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
