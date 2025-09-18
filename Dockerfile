FROM public.ecr.aws/lambda/python:3.13@sha256:20cece5a31737b73443e55d526386c3ded8c4cabd8a8cdc295290f15b780fac3

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
