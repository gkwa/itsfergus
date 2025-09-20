FROM public.ecr.aws/lambda/python:3.13@sha256:58ad792606e1d25166ae6eb2f045989577dcaca0eb5f9387b1facdbd3ce13532

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
