FROM public.ecr.aws/lambda/python:3.14@sha256:e3bc67867bcef5c1fd350d993706a133976477f747fd0e1438b4f3a26c37316e

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
