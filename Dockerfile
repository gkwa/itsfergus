FROM public.ecr.aws/lambda/python:3.15@sha256:c8ae5a0c3b57ddc941f9cc4437c9c238cbb2ae199e55bf3a12b0e31c66647907

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
