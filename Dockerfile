FROM public.ecr.aws/lambda/python:3.13@sha256:c1e64ef78dbb71832c266af01fe3d611369479f436f95580b1b2781d7e3dce22

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
