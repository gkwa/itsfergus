FROM public.ecr.aws/lambda/python:3.13@sha256:91ea5509e7904fffaad9511c514cbfae8233b081ecb8df5701f6a038304eafb4

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
