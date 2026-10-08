# Supabase setup for Udhar Khata

This app is a multi-tenant SaaS backend on Supabase: each shop owner gets an
isolated account, data is scoped with Postgres Row-Level Security, and the
app works offline via a local sqflite cache that syncs back when online.

## 1. Run the schema migration

In your Supabase project's **SQL Editor**, run `migration.sql` from this
folder once. It creates:

- `shops`, `customers`, `transactions`, `orders`, `chat_messages`, `reminders`
  — all with `uuid` primary keys, `shop_id` foreign keys, soft deletes
  (`deleted_at`), and a server-stamped `updated_at` trigger.
- A trigger that auto-creates a `shops` row the moment a user signs up
  (`handle_new_user`), so there's no separate "create your shop" step.
- Row-Level Security policies on every table scoping access to
  `shop_id in (select id from shops where owner_id = auth.uid())`.

## 2. Get your project URL + anon key

Settings → API in the Supabase dashboard. Pass them into the app via
`--dart-define` (see `lib/env.dart` for the exact flags) — never hardcode
real values into a committed file.

## 3. Email + password

This is the primary sign-in method and needs no extra setup — Supabase's
email provider is on by default. If your project requires email
confirmation (Authentication → Providers → Email → "Confirm email"), a new
sign-up won't get a session until the user clicks the confirmation link;
the app handles this by showing a "check your email" message instead of
logging them in immediately.

## 4. Phone OTP (SMS) — implemented, currently hidden from the login menu

The login screen only offers email/password and Google for now (see
`_phoneOtpEnabled` in `lib/screens/auth_screen.dart`). The phone OTP code
path (`AuthService.sendPhoneOtp`/`verifyPhoneOtp`, the OTP entry screen) is
still there and fully wired — flip that flag to `true` once you want to
offer it, after setting up an SMS provider:

1. Create a Twilio (or MessageBird) account and provision an SMS-capable
   number, or a Messaging Service for better deliverability.
2. Supabase dashboard → **Authentication → Providers → Phone** → enable it,
   choose Twilio/MessageBird, and paste the Account SID / Auth Token /
   Message Service SID.
3. SMS is billed per-message by Twilio — this is separate from Supabase's own
   pricing.

## 5. Enable Google OAuth

1. In Google Cloud Console, create an OAuth consent screen (External, scopes
   `email`, `profile`).
2. Create an OAuth Client ID of type **Web application**. Its Client ID goes
   into both:
   - Supabase dashboard → **Authentication → Providers → Google** (Client ID
     + Client Secret), and
   - the app's `GOOGLE_WEB_CLIENT_ID` dart-define (used as `google_sign_in`'s
     `serverClientId`).
   Authorized redirect URI: `https://<project-ref>.supabase.co/auth/v1/callback`.
3. Create an OAuth Client ID of type **Android**, with this app's package
   name (`com.aistudio.udhar_khata_flutter`) and the SHA-1 from
   `cd android && ./gradlew signingReport` (add both debug and release
   keystores eventually).
4. Create an OAuth Client ID of type **iOS**, with this app's bundle id
   (`com.aistudio.udharKhataFlutter`). Add its reversed-client-id URL scheme
   to `ios/Runner/Info.plist`'s `CFBundleURLTypes`.

## 6. Verify end-to-end

1. Sign up via email/password with a real address → confirm a `shops` row
   appears in the Table Editor and the app shows an empty (not demo-seeded)
   dashboard.
2. Sign up via Google on a second account → confirm a second, isolated
   `shops` row.
3. Add a customer + transaction while online → confirm it lands in the
   `customers`/`transactions` tables within ~30s (the app's sync poll
   interval).
4. Turn on airplane mode, add another customer + transaction → confirm the
   UI updates instantly and the rows are queued (check the local
   `pending_mutations` table via a debug build, or just reconnect and verify
   step 5).
5. Reconnect → confirm the queued rows appear in Supabase.
6. From a second account, confirm you cannot see the first account's data —
   this is the RLS check. Querying as the Supabase admin (bypasses RLS)
   should show both shops' rows, confirming RLS is scoping the *app's*
   anon-key access specifically.
