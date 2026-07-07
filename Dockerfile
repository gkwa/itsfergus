FROM public.ecr.aws/lambda/python:3.15@sha256:5df5d7e450228f804a1760c2024f3870ac22c31ecf6ae1e617288dc734f04241

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
