FROM public.ecr.aws/lambda/python:3.14@sha256:a46c80668dafa9e49f848eb153fd0d5f6df7db8dc24c49d9c446e712df554757

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
