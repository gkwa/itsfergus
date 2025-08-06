FROM public.ecr.aws/lambda/python:3.13@sha256:80031124585fb87628562df0909259fba3858b3e3056e3d7dfbec89fcd2e08b3

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
