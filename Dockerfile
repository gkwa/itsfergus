FROM public.ecr.aws/lambda/python:3.13@sha256:bd9ef2fffc517f083973fc500c868310fb3567845929a10502e2ac36bcd13120

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
