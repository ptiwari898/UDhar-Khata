/// Supabase project credentials, injected at build time via --dart-define.
/// The defaultValue below is only what's used if no --dart-define is
/// passed — it is NOT read from the environment itself, so a bare
/// `flutter run`/`flutter test` with no flags will use these placeholders
/// literally and fail to connect.
///
/// - Local dev: pass the real values yourself:
///     flutter run --dart-define=SUPABASE_URL=https://xxx.supabase.co --dart-define=SUPABASE_ANON_KEY=...
/// - CI (.github/workflows/release.yml): already wired to pass
///   --dart-define flags sourced from the repo's GitHub Actions secrets
///   (Settings > Secrets and variables > Actions) named exactly
///   SUPABASE_URL, SUPABASE_ANON_KEY, GOOGLE_WEB_CLIENT_ID — add those
///   secrets with your real Supabase project's values for release builds
///   to work.
const String supabaseUrl = String.fromEnvironment(
  'SUPABASE_URL',
  defaultValue: 'GH_SUPABASE_URL',
);

const String supabaseAnonKey = String.fromEnvironment(
  'SUPABASE_ANON_KEY',
  defaultValue: 'GH_ANON_KEY',
);

/// The OAuth "Web" client ID created in Google Cloud Console, also set as
/// the Client ID for the Google provider in Supabase Auth settings. Needed
/// by google_sign_in as `serverClientId` so the ID token it returns is
/// accepted by Supabase.
const String googleWebClientId = String.fromEnvironment(
  'GOOGLE_WEB_CLIENT_ID',
  defaultValue: 'YOUR_GOOGLE_WEB_CLIENT_ID.apps.googleusercontent.com',
);
