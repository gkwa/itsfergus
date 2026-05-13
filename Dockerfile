FROM public.ecr.aws/lambda/python:3.14@sha256:0f9f9c17bc7e46797bd1f31df22eeaaf8426649103f18f8b349133c69a737ef8

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
