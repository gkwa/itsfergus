FROM public.ecr.aws/lambda/python:3.15@sha256:42985e7fdfbffa63661880e018726d99f9050830d7b2b709004768a461f791bb

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
