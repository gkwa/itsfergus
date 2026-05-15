FROM public.ecr.aws/lambda/python:3.14@sha256:fa3cc85932d9e1df9bf8b4b5cb7dac7affdd86ef15a3a9f58fc8f88011ca36ab

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
