FROM public.ecr.aws/lambda/python:3.15@sha256:def6dc431ebea85760527e824ba40868170af33d845a6426e4d95f6722733732

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
