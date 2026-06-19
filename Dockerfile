FROM public.ecr.aws/lambda/python:3.14@sha256:392f3b615c62d52708fb0e61ed137ef90adab7c146d7036eeb467f8e37cf936b

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
