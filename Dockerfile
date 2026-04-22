FROM public.ecr.aws/lambda/python:3.14@sha256:a1717ec6adee57f9a89028b7ea92c54708e242a0ab75ad90008338282c9af0f7

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
