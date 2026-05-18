FROM public.ecr.aws/lambda/python:3.14@sha256:881ba35a45e6d60c56a872b918e5fd521c9e91b2fa0676345f586f2701b1f065

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
