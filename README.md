# Tumpeng Flutter app

Flutter starter for Android and iOS. The UI follows the Tumpeng identity guide in `.agents/Design system.pdf`.

## Run

```sh
flutter run \
  --dart-define=API_BASE_URL=https://your-api.example.com \
  --dart-define=GOOGLE_SERVER_CLIENT_ID=your-web-oauth-client-id
```

The generated application IDs are `id.tumpeng.tumpeng` for Android and iOS. Replace them if your release application IDs differ.

## Modules

- `lib/core/network`: Dio API client and persistent cookie jar. Cookie records are stored through `flutter_secure_storage` (Android encrypted storage / iOS Keychain). The backend should issue the session with `Set-Cookie`; use `HttpOnly`, `Secure`, and an appropriate `SameSite` policy. `clearSession()` removes the stored cookies.
- `lib/features/auth`: Google Sign-In returns an ID token and exchanges it at `POST /auth/google` by default. The backend must validate the Google token and set its own session cookie in its response. Change the endpoint in `signInAndExchange()` to match the backend.
- `lib/features/qr`: QR camera scanner and reusable QR generator.
- `lib/features/payments`: vendor-neutral payment contract. Implement it after selecting a gateway; payment credentials and transaction verification should stay on the backend.

## Onboarding and roles

On first launch, the app shows three introduction pages. The last page asks the user to choose **Hero (customer)** or **Mitra (seller)**, followed by three role-specific introduction pages. Going back from the first role page returns to the role picker. The completed role and first-run flag are saved locally; later launches open that role's login/register choices.

The email form currently expects `POST /auth/{hero|mitra}/register` and `POST /auth/{hero|mitra}/login`, with JSON fields `name` (registration only), `email`, and `password`. Google sign-in uses `POST /auth/google` with `idToken` and `role`. Successful responses should set the session cookie. Update these paths and payloads to match the backend contract. Hero and Mitra each have a separate starter dashboard; menu, order, and store data remain placeholders until the product API is connected.

## Google Sign-In setup

Register Android package `id.tumpeng.tumpeng` and iOS bundle `id.tumpeng.tumpeng` in Google Cloud or Firebase. For Android, add the signing certificate SHA-1/SHA-256 and configure a web OAuth client as the server client ID. For iOS, add `GIDClientID` and the reversed client ID URL scheme from your iOS OAuth client to `ios/Runner/Info.plist`. Supply the web client ID using `GOOGLE_SERVER_CLIENT_ID`. OAuth credentials are intentionally not committed here.

The Google button needs valid OAuth credentials and a backend implementing the exchange route. Camera scanning needs the runtime camera permission, which is declared for both platforms.

## Payment gateway

No provider is configured yet. Once selected, implement `PaymentGateway` and connect it to backend-created checkout sessions. Do not put gateway secret keys in the app.
