FROM public.ecr.aws/lambda/python:3.13@sha256:0296802827068fd2570d7dd2d1402c4f2eb756d4d8ce75e6175afee3286c3805

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
