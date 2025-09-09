FROM public.ecr.aws/lambda/python:3.13@sha256:cc8634832d60f88e53c82bdcd9708bef46b9e72a7e828219e45b26d16e1c6896

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
