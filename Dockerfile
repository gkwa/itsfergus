FROM public.ecr.aws/lambda/python:3.13@sha256:0cea15d5ffbad07278b06f03d5181a53e4514f568da9d9234b746bf4dee88524

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
