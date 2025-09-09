# flutter_dotenv_remote

Use the hosted portal at https://flutterdotenv.com to create, manage and publish environment configs, then load them in your Flutter app by ID.

This package provides an extension on `flutter_dotenv` that fetches a JSON-based environment, loads it into `dotenv`, and caches the last successful result for offline fallback.

Why use the portal
------------------

- Fast setup: sign up, create a config, copy the config ID and use it in your app.
- Centralized management: edit environment sets in a web UI and have client apps pick up latest changes by ID.
- Optional paid features & team management (coming soon).

Quick start (recommended)
-------------------------

1. Sign up at https://www.flutterdotenv.com and create a config. Copy the generated config ID.
2. Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_dotenv_remote: ^0.0.1
  flutter_dotenv: ^6.0.0
```

3. Load the config at app startup:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_dotenv_remote/flutter_dotenv_remote.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.loadRemote(
    // UUID from your environment entry on flutterdotenv.com
    configId: '699fb309-6c5c-44fb-8612-b6a8dda08296',
    useCacheOnFailure: true,
    onLoadFailure: () {
      // optional: UI fallback or logging
      debugPrint('Failed to load config from remote and cache');
    },
  );

  runApp(const MyApp());
}
```

The library defaults to the Supabase instance used by the portal; you do not need to provide keys when consuming portal configs.

Use the loaded environment variables
-------------------------

See [Flutter Dotenv](https://pub.dev/packages/flutter_dotenv) documentation for how to use the variables in your app.


Advanced / self-hosted
----------------------

If you run your own Supabase instance you can pass `supabaseUrl` and `supabaseAnonKey`, or provide a `SupabaseClient` instance (useful for testing or advanced scenarios):

```dart
await dotenv.loadRemote(
  configId: 'your-id',
  supabaseUrl: 'https://your-project.supabase.co',
  supabaseAnonKey: 'your-anon-key',
  // or
  // supabaseClient: SupabaseClient(...),
);
```

Caching and failure behaviour
-----------------------------

- On successful remote load the library caches the final dotenv string locally (SharedPreferences).
- If a remote load fails and `useCacheOnFailure` is true, the last cached config is loaded.
- If both remote and cache loading fail and an `onLoadFailure` callback is provided, it will be invoked so the app can handle the error.

Security note
-------------

The portal's Supabase anon key is used solely for reading published environment configs. Do not store sensitive secrets in public configs; use appropriate server-side controls for secrets.

Contributing & support
----------------------

Open an issue or submit a PR. For portal support and account/tier questions use https://www.flutterdotenv.com.

License
-------

This project is licensed under the terms in the repository `LICENSE` file.
