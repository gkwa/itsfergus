FROM public.ecr.aws/lambda/python:3.15@sha256:92d0229221ddbb340d12cd8a4ca462b597f84e1770d3a75cacb9430382f16b72

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
