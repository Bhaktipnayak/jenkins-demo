FROM python:3.12-slim

WORKDIR /app

COPY jenkins-demo/app.py .

CMD ["python3", "app.py"]
