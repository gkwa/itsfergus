FROM public.ecr.aws/lambda/python:3.14@sha256:b4e5c060b4c65c26438911cee02e1f81e91e8b2dc001c52380a8a4da84fb8775

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
