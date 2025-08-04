FROM public.ecr.aws/lambda/python:3.13@sha256:79230817a166ae3013e4b2207c5722d8b600114e99dd6745c46a605ae3129549

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
