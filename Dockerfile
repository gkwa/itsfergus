FROM public.ecr.aws/lambda/python:3.13@sha256:53dcfaad372124590e6a30c9e1dc0072f2322fd6f68f226c800f296c180f4b9c

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
