FROM public.ecr.aws/lambda/python:3.14@sha256:09853b5525d463ea16c4cc3561ac524eead4006fef1f1961b03f775243cf7025

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
