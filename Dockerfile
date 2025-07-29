FROM public.ecr.aws/lambda/python:3.13@sha256:680ad407e7cfdf666443d7bbeba313c143a39778dcdcadac17f7e5a857c5130c

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
