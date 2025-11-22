FROM public.ecr.aws/lambda/python:3.14@sha256:aa6142b06822702e4a3c7b4ec267e9bd631b3ab2edbfc9fa009f9c518292d8ae

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
