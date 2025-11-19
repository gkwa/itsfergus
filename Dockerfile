FROM public.ecr.aws/lambda/python:3.14@sha256:071a4336fa1b672c449687bcaacac59897deaada9effbf07ee94ebbd2489aa32

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
