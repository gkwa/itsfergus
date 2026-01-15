FROM public.ecr.aws/lambda/python:3.14@sha256:a43777e0b69383fd60dfd1110f6b0136506d5125953bed5d811e2650f2473e72

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
