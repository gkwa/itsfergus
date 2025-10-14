FROM public.ecr.aws/lambda/python:3.13@sha256:f20766174b9dc98264b802947d9dda311f1f6c33413c12a479b795d1442e4668

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
