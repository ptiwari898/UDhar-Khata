import 'package:supabase_flutter/supabase_flutter.dart';

/// Thin accessor over the singleton Supabase client, so the rest of the
/// data layer depends on this instead of importing supabase_flutter
/// directly everywhere.
class SupabaseClientWrapper {
  SupabaseClient get client => Supabase.instance.client;

  SupabaseQueryBuilder table(String name) => client.from(name);
}
