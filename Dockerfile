FROM public.ecr.aws/lambda/python:3.13@sha256:63811c90432ba7a9e4de4fe1e9797a48dae0762f1d56cb68636c3d0a7239ff68

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
