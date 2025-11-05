FROM public.ecr.aws/lambda/python:3.14@sha256:228e93608c761932bc857a42aa2b6908964049866555605d6fe747a47253c14b

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
