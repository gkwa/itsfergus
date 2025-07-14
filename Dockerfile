FROM public.ecr.aws/lambda/python:3.13@sha256:a0f66469ebd6324794f50f44a4943db71cc8cec9dda353adf0aee0c89b2d09d0

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
