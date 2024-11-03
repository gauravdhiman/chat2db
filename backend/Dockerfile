FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN apt-get update && apt-get install -y git && \
    pip install --no-cache-dir -r requirements.txt

# TODO: Remove this once phi is updated to support tools usage with structured outputs
# COPY ./.venv/lib/python3.12/site-packages/phi /usr/local/lib/python3.11/site-packages/phi

COPY . .

EXPOSE 4000

CMD ["source ./.venv/bin/activate &&;", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "4000"]