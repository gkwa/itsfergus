FROM public.ecr.aws/lambda/python:3.14@sha256:0958d2d2efadbb6fec3d4b92ae366daa93e82acbcf061393ed4ba463b4e96239

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
