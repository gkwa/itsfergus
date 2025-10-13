FROM public.ecr.aws/lambda/python:3.13@sha256:8a9d20eba322f3d73d5ae7c4e42a5df3a486dd6f243c5a9a92d1f03b132b01c2

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
