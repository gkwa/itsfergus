FROM public.ecr.aws/lambda/python:3.13@sha256:d22ec52f3a06e989e18de41ea34d7d597314825e83dda115f83c1515ca9d6cb2

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
