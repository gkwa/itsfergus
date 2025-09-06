FROM public.ecr.aws/lambda/python:3.13@sha256:364d9507271f62a95fd0a47fe746548336e85066bade8ce6409c96162abf939e

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
