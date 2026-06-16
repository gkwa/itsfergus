FROM public.ecr.aws/lambda/python:3.14@sha256:dcc8a02f86e75783ac97db7bc3c447f28f2d8ef900abc249fe4865d3aeba8e54

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
