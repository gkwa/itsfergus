FROM public.ecr.aws/lambda/python:3.13@sha256:9b9687d719b605229cbeb5972c257f80ae1a0fa45ea7b5e5954a29cfb1c1659a

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
