FROM public.ecr.aws/lambda/python:3.13@sha256:022e3954527762fe213697f5efe56311ad15deaabb142060e8ca756ed1b949a0

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
