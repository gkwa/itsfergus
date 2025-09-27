FROM public.ecr.aws/lambda/python:3.13@sha256:58e13be010de53134df9baedd36bcf55b0e11eb64a26679919721fe61c88432a

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
