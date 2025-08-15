FROM public.ecr.aws/lambda/python:3.13@sha256:308f4e536a543fe608649a4cb552203c695dda353b7b5aea15d1bd053aa36058

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
