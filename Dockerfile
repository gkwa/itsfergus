FROM public.ecr.aws/lambda/python:3.15@sha256:f0840f4640627ffcb4baf72eb54075906bcd325dcfcb8e4a881f8810d882e22e

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
