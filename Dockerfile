FROM public.ecr.aws/lambda/python:3.13@sha256:4993b1ba9acfa602ecaee33280bb868487e7c56a2b1cb58feb43f5cb7c4be60b

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
