FROM public.ecr.aws/lambda/python:3.14@sha256:f244f3320e7880813ab146a2d558acbc4303314dc42822e37b6e6a1bc8064244

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
