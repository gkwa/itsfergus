FROM public.ecr.aws/lambda/python:3.14@sha256:8befc58bb0f2e636777aa73cc006b04e5c009f2dc7b42ed7bf891e14daa33d93

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
