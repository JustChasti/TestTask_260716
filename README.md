# TestTask_260716

Тестовое задание на позицию DevOps: локальный стенд веб-приложения с Nginx, backend, PostgreSQL и Redis.

## Состав

- Nginx: reverse proxy и TLS termination, порт 443 (self-signed сертификат)
- backend: Flask-приложение, порт 8080
- PostgreSQL 15: база данных
- Redis 7: кэш сессий

## Требования

- Docker
- Docker Compose
- OpenSSL (для генерации сертификата)

## Запуск

```bash
cp .env-example .env
./gen-certs.sh
docker compose up --build -d
docker compose ps
```

После запуска приложение доступно по адресу [https://localhost](https://localhost). Сертификат самоподписанный, браузер покажет предупреждение о безопасности.

## Конфигурация

Пароли и переменные задаются в `.env` на основе `.env-example`:

| Переменная | Описание |
|---|---|
| `POSTGRES_USER` | пользователь PostgreSQL |
| `POSTGRES_PASSWORD` | пароль PostgreSQL |
| `POSTGRES_DB` | имя базы данных |
| `REDIS_PASSWORD` | пароль Redis |

## Nginx

- Порт 443 принимает TLS, порт 80 делает редирект на https.
- На backend передаются заголовки `Host`, `X-Real-IP`, `X-Forwarded-For`, `X-Forwarded-Proto`, `X-Forwarded-Host`.
- Rate limiting: 10 запросов в секунду с одного IP, burst 20 (`limit_req_zone` в `nginx/nginx.conf`).
- Ограничение размера тела запроса: 10MB (`client_max_body_size`).
- Healthcheck доступен по пути `/healthz`.

## Проверка

Заголовки, полученные backend:

```bash
curl -sk https://localhost/
```

Rate limiting (часть запросов вернёт код 503 после превышения лимита):

```bash
for i in {1..30}; do curl -sk -o /dev/null -w "%{http_code}\n" https://localhost/; done
```

Статус healthcheck всех сервисов:

```bash
docker compose ps
```

## Стек

Nginx, Flask, PostgreSQL 15, Redis 7, Docker Compose
