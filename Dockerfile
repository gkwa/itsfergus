FROM public.ecr.aws/lambda/python:3.14@sha256:36fdfadbb234d8f1e07fb30cd458fb7812cc4309f5b4bc5aec092c328061f3ea

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
