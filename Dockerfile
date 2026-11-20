FROM public.ecr.aws/lambda/python:3.15@sha256:9029e436c0b239994ea21447f17d407834d624a2df7cd912a6d506ea1e15f168

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
