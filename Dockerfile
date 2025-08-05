FROM public.ecr.aws/lambda/python:3.13@sha256:7c0b6f5a3937f34b2ff0553898dce1a8711c3da6f789f6c4b495e54618a930e2

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
