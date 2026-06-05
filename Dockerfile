FROM public.ecr.aws/lambda/python:3.14@sha256:fd7f5db735b3e5e952adb842976f66eb437ef7e4b156f464109d05261fc37270

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
