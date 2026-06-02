FROM public.ecr.aws/lambda/python:3.14@sha256:d9d15824409d2dc271a3c59153ce4f59b987cc03b5deab7277eadee8184dd67a

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
