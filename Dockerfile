FROM public.ecr.aws/lambda/python:3.14@sha256:6684f987e7b9c1e17e7587434444987f18d80f34b9c934ca07698b0282667778

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
