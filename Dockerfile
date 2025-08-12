FROM public.ecr.aws/lambda/python:3.13@sha256:896f5b5410c9d6f2584d9230e5485793354c0c62b1984b98c7f2bcf1815412ce

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
