FROM public.ecr.aws/lambda/python:3.15@sha256:ea078237ea149b9310d94cb9fd873f4df4e9d45844c95cdf9cebb8b163b8d7ec

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
