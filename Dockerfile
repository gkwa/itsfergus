FROM public.ecr.aws/lambda/python:3.13@sha256:92367e96b60cbb24efaefe04f7c94302d5cb272ae0ff6b2becf545f650dd0541

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
