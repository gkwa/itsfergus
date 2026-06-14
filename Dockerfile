FROM public.ecr.aws/lambda/python:3.14@sha256:9375d121da6b1f7a2f50700898ddd62095d842937e40149b3dbe069464d9cc69

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
