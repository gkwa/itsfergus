FROM public.ecr.aws/lambda/python:3.14@sha256:75997ee49a8c899afc6f3f93aea40b27537f04353095487e745f5846cedfa3d4

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
