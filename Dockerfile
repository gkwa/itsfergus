FROM public.ecr.aws/lambda/python:3.14@sha256:c7fd51ccbd7d39b3df8899d6ec3af97c62e1cc46f05f78fda903f7e1451721cf

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
