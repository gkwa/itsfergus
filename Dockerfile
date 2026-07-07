FROM public.ecr.aws/lambda/python:3.14@sha256:42416c337ba1e1cf5e09326b86db3c697ae4010e519dbe77848f15253263ab86

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
