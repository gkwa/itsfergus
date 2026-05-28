FROM public.ecr.aws/lambda/python:3.14@sha256:728573760138c101ea839ef197f91660c1f9330498eafb34ea5b3812fa581186

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
