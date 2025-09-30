FROM public.ecr.aws/lambda/python:3.13@sha256:d9edaacb31059fc0ac2a98849ef5c271df0a81be36e8d78dfb72a414483f2e0a

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
