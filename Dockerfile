FROM public.ecr.aws/lambda/python:3.14@sha256:dfb3cdcd206d051dd1e09c5afa889c09d6d6393a68bf1906f81ab94d02649e71

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
