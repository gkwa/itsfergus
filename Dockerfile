FROM public.ecr.aws/lambda/python:3.13@sha256:926361675767ea3d8ef9e6230a768e7962a35a083cca1c2c94338237081a01d1

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
