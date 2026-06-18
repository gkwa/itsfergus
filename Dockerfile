FROM public.ecr.aws/lambda/python:3.14@sha256:875cf39e4613cd416b1413ac0e71b61713faae9fa2d1fdea89b91fe895e9069d

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
