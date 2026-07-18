FROM public.ecr.aws/lambda/python:3.15@sha256:fc444ca6b1386d26573ae762b205bd29fb95345e5e59990e14cb5d44b8131ba5

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
