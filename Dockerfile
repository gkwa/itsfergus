FROM public.ecr.aws/lambda/python:3.15@sha256:ccd3496ae99acd0a2994a1018497ebe9c34cae27bd1847e5a6ef60fa203c79fc

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
