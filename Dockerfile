FROM public.ecr.aws/lambda/python:3.14@sha256:0c835d3c9914f58235f5e06d57518da4e93352be1969f4f2b28718a08b7a2745

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
