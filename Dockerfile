FROM public.ecr.aws/lambda/python:3.14@sha256:825f33e31697d62cc8e81a019ad49c1bfbaec5c10fd76ba715f9a7b959c3dcfa

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
