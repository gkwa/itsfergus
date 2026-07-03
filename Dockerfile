FROM public.ecr.aws/lambda/python:3.14@sha256:334a554adabe8906ad3e7eddf52a75ed3f73a73da7f20cc0724f018c5171b611

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
