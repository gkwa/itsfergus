FROM public.ecr.aws/lambda/python:3.14@sha256:aa45586392d81b3e3bfdd0b45962183ca69b5d10faafbd89a44db84ce5b5a0b1

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
