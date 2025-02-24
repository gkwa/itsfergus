FROM public.ecr.aws/lambda/python:3.13@sha256:ba085c72bda72d9111dae65c88cbf0dc26f7fd26c975ee0dbc70f1aa75d3f1c5

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
