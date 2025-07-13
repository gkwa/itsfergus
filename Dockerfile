FROM public.ecr.aws/lambda/python:3.13@sha256:20232ac5a0f7a24bbd30f81503430203ff75f7e2f9ef73c64782c8f2d2020031

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
