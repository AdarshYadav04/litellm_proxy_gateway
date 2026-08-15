FROM python:3.12-slim

WORKDIR /app

# System deps for prisma / postgres
RUN apt-get update && apt-get install -y --no-install-recommends \
    openssl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Generate the Prisma client at build time
RUN prisma generate --schema=/app/venv_schema.prisma || \
    python -c "import litellm_proxy_extras, os; print(os.path.dirname(litellm_proxy_extras.__file__))" && \
    SCHEMA_PATH=$(python -c "import litellm_proxy_extras, os; print(os.path.join(os.path.dirname(litellm_proxy_extras.__file__), 'schema.prisma'))") && \
    prisma generate --schema=$SCHEMA_PATH

EXPOSE 4000

CMD ["litellm", "--config", "litellm_config.yaml", "--port", "4000", "--host", "0.0.0.0"]