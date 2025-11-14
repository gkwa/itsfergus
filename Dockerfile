FROM public.ecr.aws/lambda/python:3.14@sha256:96e167cbd479a2295e7e18a5d649120775935a12498016ab0ad6e1fd18bdb981

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY app.py ${LAMBDA_TASK_ROOT}

CMD [ "app.handler" ]
