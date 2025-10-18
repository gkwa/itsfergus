FROM public.ecr.aws/lambda/python:3.13@sha256:279701042273883073be360383fc0c95ff1422ec4f8e5981b584a606be00b729

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
