FROM public.ecr.aws/lambda/python:3.14@sha256:84b0686d474c9a35dfafde2315e19deed811ea6d2d6ff61040ebb70a7de66233

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
