import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

import 'providers/auth_provider.dart';
import 'routing/app_router.dart';

import 'core/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final prefs = await SharedPreferences.getInstance();
  final initialToken = prefs.getString('auth_token');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..initializeSession(initialToken)),
      ],
      child: const IntellifyWorxApp(),
    ),
  );
}

class IntellifyWorxApp extends StatefulWidget {
  const IntellifyWorxApp({super.key});

  @override
  State<IntellifyWorxApp> createState() => _IntellifyWorxAppState();
}

class _IntellifyWorxAppState extends State<IntellifyWorxApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = createAppRouter(context.read<AuthProvider>());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'IntellifyWORX',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: _router,
    );
  }
}
