FROM public.ecr.aws/lambda/python:3.15@sha256:ff118eaa5fb0e4a322ae28c5b8a7337f5396eaca5f34d613b904b444f8a32dc0

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
