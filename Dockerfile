FROM public.ecr.aws/lambda/python:3.15@sha256:c2527057f6caae537c14848510ed5d4b8d5d639be621f1fca1605c4494d3bf09

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
