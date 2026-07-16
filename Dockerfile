FROM public.ecr.aws/lambda/python:3.15@sha256:de38328134f76ff6b131144e9d982ac2aa4f53f4a7f06ec67e10face1d90323c

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
