FROM public.ecr.aws/lambda/python:3.14@sha256:01e8f793d231e9270cb62e74d05e6b797fb85c587a25ccb0b35f231e3a213fc3

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
