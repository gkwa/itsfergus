FROM public.ecr.aws/lambda/python:3.13@sha256:507b85226a0cbc1e86701f2e5cf6ae4619134aa07f09f00622dab9186ef00bf9

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
