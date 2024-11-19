FROM python:3.11-slim

USER root

WORKDIR /app

COPY . .

RUN pip install --no-cache-dir -r requirements.txt

CMD [ "pytest" ]