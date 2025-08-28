# flutter_dotenv_remote_extension

Easily load environment variables from a remote Supabase table into your Flutter app using the familiar `flutter_dotenv` API. This package provides a drop-in extension for `flutter_dotenv` that supports remote config loading, offline caching, and flexible error handling.

## Features

- Load environment variables from a Supabase table by config ID
- Automatic caching for offline use
- Fallback to last cached config if online fetch fails (optional)
- Custom error/fallback handler if both online and cache loading fail
- Works seamlessly with `flutter_dotenv`

## Getting started

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_dotenv_remote_extension: ^0.0.1
```

All required dependencies (`flutter_dotenv`, `supabase_flutter`, `shared_preferences`) are handled automatically.

## Usage

### Basic usage (default hosted Supabase instance)

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_dotenv_remote_extension/flutter_dotenv_remote_extension.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.loadRemote(
    configId: 'YOUR_CONFIG_ID', // e.g. '699fb309-6c5c-44fb-8612-b6a8dda08296'
    useCacheOnFailure: true, // fallback to cache if offline
    onLoadFailure: () {
      // Show error UI or log
      print('Failed to load config from both remote and cache');
    },
  );

  runApp(MyApp());
}
```

### Display loaded environment variables

```dart
final envVars = dotenv.env.entries.toList();
return ListView.builder(
  itemCount: envVars.length,
  itemBuilder: (context, index) {
    final entry = envVars[index];
    return ListTile(
      title: Text(entry.key),
      subtitle: Text(entry.value),
    );
  },
);
```

## Advanced usage

### Use your own Supabase instance

You can override the default Supabase URL and anon key:

```dart
await dotenv.loadRemote(
  configId: 'YOUR_CONFIG_ID',
  supabaseUrl: 'https://your-project.supabase.co',
  supabaseAnonKey: 'your-anon-key',
);
```

### Custom error handling

Provide an `onLoadFailure` callback to handle cases where both remote and cache loading fail:

```dart
await dotenv.loadRemote(
  configId: 'YOUR_CONFIG_ID',
  useCacheOnFailure: true,
  onLoadFailure: () {
    // Show a dialog, log, or fallback to defaults
  },
);
```

## How it works

- Loads config from Supabase table `envs` where `id = configId`
- Parses the `environment_json` field (should be a JSON object of key-value pairs)
- Loads the config into `flutter_dotenv` using `loadFromString`
- Caches the last loaded config in `SharedPreferences` for offline use

## Example

See the `/example` folder for a complete Flutter app that loads and displays remote config.

## Additional information

- [flutter_dotenv](https://pub.dev/packages/flutter_dotenv)

Feel free to file issues, contribute, or reach out for support!
