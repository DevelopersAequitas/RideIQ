## RydeIQ Driver Truv APIs — Flutter Handover (Clean Architecture)

### Base URL
- **Local**: `http://127.0.0.1:8000/api`
- **Ngrok**: `https://your-ngrok-url.ngrok-free.app/api`
- **Production**: `https://yourdomain.com/api`

> Your Flutter app currently uses `ApiConstants.baseUrl` (see `lib/core/constants/api_constants.dart`). Ensure it matches the active environment.

### Authentication (All endpoints)
Required headers:
- **Authorization**: `Bearer DRIVER_LOGIN_TOKEN`
- **Accept**: `application/json`
- **Content-Type**: `application/json`

### Full Flow Order (Flutter)
1. Driver login (obtain driver token)
2. `POST /driver/truv/create-token`
3. Open Truv Bridge SDK using returned `bridge_token`
4. Receive `public_token` from SDK callback
5. `POST /driver/truv/exchange-token`
6. `GET /driver/truv/status`
7. `GET /driver/truv/report` (optional)
8. Continue onboarding

---

## API 1 — Create Token
### Purpose
Generate a fresh Truv bridge token for opening the Truv Bridge SDK.

### Endpoint
- **Method**: `POST`
- **Path**: `/driver/truv/create-token`
- **Auth required**: Yes

### Body
No body.

### Success Response
```json
{
  "status": true,
  "message": "Bridge token created",
  "data": {
    "bridge_token": "token_here",
    "truv_user_id": "usr_xxx"
  }
}
```

### Flutter usage notes
- Use `data.bridge_token` to open Truv Bridge.
- Store only for the session; do not persist secrets.

---

## API 2 — Exchange Token
### Purpose
Send `public_token` (from Truv Bridge SDK) to backend.

### Endpoint
- **Method**: `POST`
- **Path**: `/driver/truv/exchange-token`
- **Auth required**: Yes

### Body
```json
{
  "public_token": "public_token_from_truv_sdk"
}
```

### Success Response
```json
{
  "status": true,
  "message": "Driver connected successfully"
}
```

### Flutter usage notes
- Call immediately after SDK success callback.

---

## API 3 — Status
### Purpose
Check if driver is connected/verified.

### Endpoint
- **Method**: `GET`
- **Path**: `/driver/truv/status`
- **Auth required**: Yes

### Success Response
```json
{
  "status": true,
  "data": {
    "verification_status": "connected",
    "truv_user_id": "usr_xxx",
    "link_id": "lnk_xxx",
    "connected_at": "2026-04-28 11:10:00",
    "verified_at": null
  }
}
```

### Possible `verification_status` values
- `pending`
- `connected`
- `verified`
- `failed`

---

## API 4 — Report
### Purpose
Fetch employment/income report.

### Endpoint
- **Method**: `GET`
- **Path**: `/driver/truv/report`
- **Auth required**: Yes

### Success Response
```json
{
  "status": true,
  "message": "Report fetched",
  "data": {
    "employments": [
      {
        "job_title": "Driver",
        "company": { "name": "Walgreens" }
      }
    ]
  }
}
```

### Flutter usage notes
- UI can display: **Verified Employer** / **Income Source Connected**

---

## Implementation in this repo (where to look)
This repo includes a clean feature module:
- **Models (Freezed)**: `lib/features/driver_truv/model/driver_truv_models.dart`
- **Repository**: `lib/features/driver_truv/repository/driver_truv_repository.dart`
- **ViewModel (Riverpod AsyncNotifier)**: `lib/features/driver_truv/viewmodel/driver_truv_viewmodel.dart`
- **Optional UI screen (ConsumerWidget)**: `lib/features/driver_truv/view/screens/driver_truv_verification_screen.dart`

The repository uses `ApiService` (Dio) + `ApiConstants.*` endpoint constants.

---

## Common Errors
- **401**: wrong/expired bearer token
- **422**: missing `public_token`
- **500**: backend issue

## Security note (must-follow)
Never store Truv `client_id`, `secret`, or any Truv access tokens in Flutter. Only call backend APIs.

