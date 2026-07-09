FROM public.ecr.aws/lambda/python:3.15@sha256:a66c972ff5938d5337751f5bdd21c9a70391a95b2df26caa4b2d6109a0bd13b0

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
