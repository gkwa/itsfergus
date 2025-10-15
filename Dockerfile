FROM public.ecr.aws/lambda/python:3.13@sha256:2735b69b60db7c5b4814e59526195e206d8c973983e5db5c2a6de42ae7080323

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
