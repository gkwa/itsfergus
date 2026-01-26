FROM public.ecr.aws/lambda/python:3.14@sha256:4393397eea528d359cd60ad8addb9670914acf307c1963eed30e1eaa9a6b9677

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
