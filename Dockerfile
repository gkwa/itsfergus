FROM public.ecr.aws/lambda/python:3.13@sha256:bbe9f9f7171227fc84108359ea024a1b8683c610b508ccba6eec7866bccc79d2

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
