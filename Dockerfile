FROM python:3.9-slim AS build
WORKDIR /app
RUN apt-get update && apt-get install -y gcc && python3 -m venv /opt/venv
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt
COPY . .
#Runtime Stage
FROM python:3.9-slim
WORKDIR /app
COPY --from=build /opt/venv /opt/venv
COPY --from=build /app .
ENV PATH="/opt/venv/bin:$PATH"
RUN groupadd --system --gid 1001 appgroup && useradd --system --uid 1001 appuser --gid appgroup appuser
RUN chown -R appuser:appgroup /app
USER appuser
EXPOSE 5000
CMD ["python3", "app.py"]
