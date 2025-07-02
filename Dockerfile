FROM public.ecr.aws/lambda/python:3.13@sha256:f768578ae7e8ccd0652916995dbae034c3fb2a1d159ebc492be2078fca3d0c7c

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
