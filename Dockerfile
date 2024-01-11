FROM python:3.10-bullseye
WORKDIR /app
COPY requirments.txt .
RUN pip install -r requirments.txt
COPY app.py .
EXPOSE 5000
CMD ["python", "-m","flask","run","--host=0.0.0.0"]
