FROM public.ecr.aws/lambda/python:3.14@sha256:8ae59ce52deaac9d08c4417e31b47bee40fdd0effa28cf0fbda0ccadcb861eac

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
