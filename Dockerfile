FROM public.ecr.aws/lambda/python:3.13@sha256:323ceea53fd056fc28c5d171d04ca0061981b7a135e0f695657c6a6b4da8fcfe

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
