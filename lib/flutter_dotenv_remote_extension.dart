import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

extension RemoteDotEnvExtension on DotEnv {
  /// Loads environment variables from Supabase `envs` table using a configId.
  ///
  /// This function will attempt to fetch the config from Supabase and load it into dotenv.
  /// On successful online load, the config is cached locally for offline use.
  ///
  /// If online loading fails, you can optionally fall back to the last cached config
  /// by setting [useCacheOnFailure] to true. If both online and cache loading fail,
  /// you can provide an [onLoadFailure] callback to handle the error (e.g., show a message).
  ///
  /// Parameters:
  /// - [configId]: The config identifier to fetch.
  /// - [supabaseUrl]: Your Supabase project URL (default provided).
  /// - [supabaseAnonKey]: Your Supabase anon/public key (default provided).
  /// - [supabaseClient]: Optional custom Supabase client (for testing).
  /// - [useCacheOnFailure]: If true, use last cached config if online fetch fails.
  /// - [onLoadFailure]: Callback called if both online and cache loading fail.
  Future<void> loadRemote({
    required String configId,
    String supabaseUrl = "https://przdvuyybriofvvnijrl.supabase.co",
    String supabaseAnonKey =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InByemR2dXl5YnJpb2Z2dm5panJsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTU2NTk2OTEsImV4cCI6MjA3MTIzNTY5MX0.wx7g5qWcmuw8G2lE8_yx4ONyKlr1b9dQzMZ9gvhrVT0",
    SupabaseClient? supabaseClient,
    bool useCacheOnFailure = false,
    Future<void> Function()? onLoadFailure,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'flutter_dotenv_remote_$configId';
    String? envString;

    // Try online fetch first
    try {
      final supabase =
          supabaseClient ?? SupabaseClient(supabaseUrl, supabaseAnonKey);
      final response = await supabase
          .from('envs')
          .select('environment_json')
          .eq('id', configId)
          .single();

      if (response['environment_json'] == null) {
        throw Exception('No environment found for configId: $configId');
      }

      final envMap = response['environment_json'] is String
          ? json.decode(response['environment_json'])
          : response['environment_json'];

      if (envMap is! Map) {
        throw Exception('environment_json is not a valid JSON object');
      }

      envString = envMap.entries.map((e) => '${e.key}=${e.value}').join('\n');

      // Save to cache
      await prefs.setString(cacheKey, envString);
    } catch (e) {
      // If online fetch fails, try cache if allowed
      if (useCacheOnFailure) {
        envString = prefs.getString(cacheKey);
      }
      // If still no envString, call onLoadFailure if provided
      if (envString == null && onLoadFailure != null) {
        await onLoadFailure();
        return;
      }
      // If not using cache and no fallback, rethrow
      if (envString == null) {
        rethrow;
      }
    }

    // Load into dotenv
    loadFromString(envString: envString!);
  }
}
