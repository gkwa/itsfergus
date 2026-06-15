FROM public.ecr.aws/lambda/python:3.14@sha256:001f8ea38abb78eedc6060fdd3932e9b7ddc6de889d28d15ca8e4006d352ebde

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
