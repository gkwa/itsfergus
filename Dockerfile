FROM public.ecr.aws/lambda/python:3.13@sha256:c9419beaca14fb851aca6f9432ec8fc0ad039eb0591df5c92e671ddd210fd2ac

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
