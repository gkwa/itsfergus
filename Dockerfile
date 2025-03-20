FROM public.ecr.aws/lambda/python:3.13@sha256:d6e7775386d9b1b433c7ee63b3312f281fd2d3bb885161e09f68636a33e25b18

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
