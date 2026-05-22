FROM public.ecr.aws/lambda/python:3.14@sha256:9166df1fb659d0eb66db1a8dd8353899ae5bea86f932468eddb866b87a44a80f

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
