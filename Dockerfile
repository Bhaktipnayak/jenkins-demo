FROM python:3.12-slim

WORKDIR /app

COPY jenkins-demo/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY jenkins-demo/app.py .

EXPOSE 5000

CMD ["python3", "app.py"]
