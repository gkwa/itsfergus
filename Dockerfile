FROM public.ecr.aws/lambda/python:3.13@sha256:9cde9a4333582a8b49fe90429236b2b99b9d518548cf2b720317e80f0d35634b

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
