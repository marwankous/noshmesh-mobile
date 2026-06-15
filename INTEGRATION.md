# Clypify Mobile — Backend Integration

## Architecture

The Flutter app is a pure client of the Go backend. All business logic, entitlements, and AI processing live in the backend. The app has no RevenueCat or in-app billing — subscriptions are managed entirely through the web app and the `subscription_status` field returned by the backend.

**Base URL (production):** `https://clypify.com/api/v1`  
**Base URL (local dev):** `http://10.0.2.2:8000/v1` (Android emulator) or `http://localhost:8000/v1`

---

## Authentication

### Standard login / signup
- `POST /auth/login` — returns `access_token` + `refresh_token`
- `POST /auth/signup` — triggers email verification
- `POST /auth/email/verify?token=...` — verifies email
- `POST /auth/token/refresh` — refresh access token
- `POST /auth/logout`

Tokens are stored via `flutter_secure_storage`. The Dio interceptor handles 401s and auto-refreshes.

### Google OAuth (mobile deep-link flow)
1. App opens `https://clypify.com/api/auth/google/login?redirect_uri=clypify://auth/callback` in a Chrome Custom Tab via `flutter_web_auth_2`.
2. Backend redirects the user to Google, then handles the callback at `/auth/google/callback`.
3. Backend redirects to `clypify://auth/callback?access_token=...&refresh_token=...`.
4. The app intercepts the deep link and extracts the tokens.

**Required backend `.env` settings:**
```
GOOGLE_OAUTH_REDIRECT_URL=https://clypify.com/api/auth/google/callback
ALLOWED_CALLBACK_ORIGINS=https://clypify.com,http://localhost:4200,clypify://
```

The `clypify://` scheme is registered in `android/app/src/main/AndroidManifest.xml` for `flutter_web_auth_2.CallbackActivity`.

---

## User / Subscription

- `GET /me` — returns user profile including `subscription_status`, `plan` (with `name`, `max_monthly_tokens`), `monthly_tokens_used`
- Subscription upgrades happen on the web; the app reads the current status from `/me` on each session start.

---

## Core Features

| Feature | Endpoint |
|---------|----------|
| List RSS feeds | `GET /app/rss` |
| Add RSS feed | `POST /app/rss` |
| Sync feed | `POST /app/rss/{id}/fetch` |
| List articles | `GET /app/articles` |
| List merged content | `GET /app/merged-content` |
| Create merged content | `POST /app/merged-content` |
| Get merged content | `GET /app/merged-content/{id}` |
| Update merged content | `PUT /app/merged-content/{id}` |
| Publish to Ghost/WP | `POST /app/merged-content/{id}/publish` |
| List external endpoints | `GET /app/external-endpoints` |
| Add external endpoint | `POST /app/external-endpoints` |

See `backend/FRONTEND_API_DOCS.md` for full request/response shapes.

---

## Plan Limits

- `402 Payment Required` — monthly token quota exhausted (AI endpoints)
- `403 Forbidden` — plan limit reached (e.g. max RSS feeds)

Show an upsell prompt and direct the user to the web app to upgrade.
