FROM public.ecr.aws/lambda/python:3.13@sha256:1618ba836b700c8bf3daa2637e0949a323724bfca49b751a4ff4614295da9402

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
