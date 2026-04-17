FROM public.ecr.aws/lambda/python:3.14@sha256:0eb7617a732e1b094ed84bc47fcff185d4d8ace8468f8347029979ffe410fcad

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
