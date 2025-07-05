FROM public.ecr.aws/lambda/python:3.13@sha256:72332a63d9ba2bc8fb82ee669566b8380ff9400203e98e04a826ba32beca3a36

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
