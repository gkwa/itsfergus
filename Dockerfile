FROM public.ecr.aws/lambda/python:3.13@sha256:466809a45ae3765e753081092eaecc16cbf97e7171a20569a1180556855e7447

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
