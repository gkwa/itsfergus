FROM public.ecr.aws/lambda/python:3.14@sha256:3550baf11e94cb808d86f322e7b262f7cb9c218fd45ab1eb104c023dec358338

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
