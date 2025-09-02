FROM public.ecr.aws/lambda/python:3.13@sha256:c6f841fa250ace2604902672113b0f40684ee442739eeb57f9e7d769b6d797ff

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
