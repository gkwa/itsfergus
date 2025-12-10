FROM public.ecr.aws/lambda/python:3.14@sha256:42e9c5be7f957890a0de12ad4cd4fb7240d45915092bbd06f6da6f3226920261

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
