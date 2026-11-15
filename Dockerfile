FROM public.ecr.aws/lambda/python:3.15@sha256:33a929226b634d0aa88b19e895c5e01a676c2f97485410e1422e41e1a5fc598f

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
