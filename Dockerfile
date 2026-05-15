FROM public.ecr.aws/lambda/python:3.14@sha256:c78fae22ed86aedf25666c470abd39ef54e321ed215409a3742931c01bdd80aa

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
