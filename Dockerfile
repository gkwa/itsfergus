FROM public.ecr.aws/lambda/python:3.13@sha256:25407489572e0a850e82d79f30ffa19857fd4acf3308c873c59bc233888b437e

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
