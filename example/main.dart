import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_dotenv_remote/flutter_dotenv_remote.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load remote env before running the app
  await dotenv.loadRemote(configId: '699fb309-6c5c-44fb-8612-b6a8dda08296');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final envVars = dotenv.env.entries.toList();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Remote Env Example')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: envVars.isEmpty
              ? const Text('No environment variables loaded.')
              : ListView.builder(
                  itemCount: envVars.length,
                  itemBuilder: (context, index) {
                    final entry = envVars[index];
                    return ListTile(
                      title: Text(entry.key),
                      subtitle: Text(entry.value),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
