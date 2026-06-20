FROM public.ecr.aws/lambda/python:3.14@sha256:3bd8f5609ac09461a17f3328bf96397796e49a6c617a143bae9bb5a476c2220d

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
