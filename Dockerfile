FROM public.ecr.aws/lambda/python:3.14@sha256:1c71fa6836704ee685593cc1e72f292da04a6b0b88ab24d5ca4e8dc36f9fd5e8

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
