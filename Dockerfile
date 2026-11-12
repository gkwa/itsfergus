FROM public.ecr.aws/lambda/python:3.15@sha256:6f1a65ef67b05ada3ed00ebf2dc88dfcd5b3ebd52431bf369336a234ba685c69

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
