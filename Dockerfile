FROM public.ecr.aws/lambda/python:3.15@sha256:fb2b0ee9404b4f66f7d0d02c9851cc10a5e335a0d4e8613454e974f8f0381eea

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
