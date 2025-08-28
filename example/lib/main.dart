import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_dotenv_remote/flutter_dotenv_remote.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.loadRemote(configId: 'b9420180-b53c-434e-9fe6-f62424720fbc');

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
