# Notification Center

A Rails API service for managing in-app notifications. Users receive notifications that can be marked as read or closed. Notifications are created via RabbitMQ messages from other services.

## Stack

- Ruby 3.2.3 / Rails 7.1
- MySQL
- RabbitMQ (Bunny)
- JWT authentication
- Sentry for error tracking

## How It Works

### Authentication

Every API request must include a Bearer token in the `Authorization` header:

```
Authorization: Bearer <token>
```

Tokens are decoded using `AuthService` with `JWT_SECRET`. The JWT payload must contain a `user_id` field that maps to a record in the `users` table.

```ruby
# app/services/auth_service.rb
payload = JWT.decode(token, ENV.fetch('JWT_SECRET'), true, algorithm: 'HS256').first
user = User.find_by(id: payload['user_id'])
```

Adapt `AuthService` to match however your auth system issues tokens.

### Notifications API

All endpoints are under `/api/site/v1/` and require authentication.

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/site/v1/notifications` | List all non-closed notifications for current user |
| PUT | `/api/site/v1/notifications/read_all` | Mark all notifications as read |
| PUT | `/api/site/v1/notifications/:uuid/read` | Mark a single notification as read |
| PUT | `/api/site/v1/notifications/:uuid/close` | Close a notification |

**Response format:**

```json
[
  {
    "uuid": "550e8400-e29b-41d4-a716-446655440000",
    "title": "Payment successful",
    "description": "Your payment of $10.00 was processed.",
    "button_title": "View receipt",
    "button_url": "https://example.com/receipts/123",
    "status": "new",
    "style": "success",
    "is_closable": true,
    "created_at": "2024-04-11T09:02:12.000Z"
  }
]
```

**Notification statuses:** `new`, `read`, `closed`

**Notification styles:** `no`, `success`, `warning`, `error`

### Creating Notifications (via RabbitMQ)

Notifications are created by publishing a message to RabbitMQ. The `CreateNotificationConsumer` listens on the `notification_center.create_notification` queue.

**Message format:**

```json
{
  "title": "Payment successful",
  "description": "Your payment was processed.",
  "button_title": "View receipt",
  "button_url": "https://example.com/receipts/123",
  "style": 1,
  "is_closable": true,
  "user_ids": [1, 2, 3]
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `title` | string | yes | Notification title |
| `user_ids` | array | yes | IDs of users to notify |
| `description` | string | no | Body text |
| `button_title` | string | no | CTA button label |
| `button_url` | string | no | CTA button URL |
| `style` | integer | no | `0` no, `1` success, `2` warning, `3` error |
| `is_closable` | boolean | no | Whether the user can dismiss it (default: `true`) |
| `uuid` | string | no | Custom UUID; auto-generated if omitted |

To start the consumer:

```bash
bin/create-notification-consumer
```

## Setup

**1. Clone and install dependencies:**

```bash
git clone <repo>
cd notifications
bundle install
```

**2. Configure environment:**

```bash
cp .env.example .env
# edit .env with your values
```

**3. Configure database:**

```bash
cp config/database.yml.example config/database.yml
# edit config/database.yml with your credentials
```

**4. Create and migrate the database:**

```bash
bin/rails db:create db:migrate
```

**5. Start the server:**

```bash
bin/rails server
```

## Environment Variables

| Variable | Description |
|----------|-------------|
| `JWT_SECRET` | Secret key used to verify JWT tokens |
| `MYSQL_HOST` | MySQL host |
| `MYSQL_USER` | MySQL user |
| `MYSQL_PASS` | MySQL password |
| `MYSQL_DB` | MySQL database name |
| `AMQP_URL` | RabbitMQ connection URL (e.g. `amqp://localhost:5672`) |
| `SENTRY_DSN` | Sentry DSN for error tracking (optional) |

## Running with Docker

```bash
docker build -t notification-center .
docker run -p 3000:3000 \
  -e JWT_SECRET=secret \
  -e MYSQL_HOST=host.docker.internal \
  -e MYSQL_USER=root \
  -e MYSQL_PASS=password \
  -e MYSQL_DB=notifications \
  -e AMQP_URL=amqp://host.docker.internal:5672 \
  notification-center
```

## Running Tests

```bash
bundle exec rspec
```

## Customization

- **Auth**: Edit `app/services/auth_service.rb` to match your token format or auth provider.
- **User model**: The `User` model is intentionally minimal (just `email`). Add whatever columns your application needs and create a migration.
- **AMQP consumer**: Add new consumers by subclassing `BasicConsumer` and overriding `process`.
