FROM public.ecr.aws/lambda/python:3.14@sha256:9b733b49723ee273580dd0962a2ef71fc4df644436662df260be21caa588d467

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
