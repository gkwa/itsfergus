FROM public.ecr.aws/lambda/python:3.13@sha256:403a6ced74330130e1e035c773eb538a4846bdc14c5e89296d3f008dcc8377a5

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
