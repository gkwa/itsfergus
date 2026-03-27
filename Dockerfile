FROM public.ecr.aws/lambda/python:3.14@sha256:6c696643fe9533189aacd0277f2a355f3325a4fe521abf3252d64130cd9fbe10

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
