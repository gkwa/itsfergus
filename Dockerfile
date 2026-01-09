FROM public.ecr.aws/lambda/python:3.14@sha256:8fc63f656b0907dd77dd8158e807302ebffc081b82544f46cd97bd56a3af85a0

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
