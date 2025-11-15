FROM public.ecr.aws/lambda/python:3.14@sha256:68c03c299a73a1bba0cb99d7395954404a484161e2bb996dd6b6ef80126983b3

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
