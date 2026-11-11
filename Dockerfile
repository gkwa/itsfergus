FROM public.ecr.aws/lambda/python:3.15@sha256:d26bb71603254f66c1f0baa66b066f19a0bb06336c1bf5e8869c2ace59b26f51

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
