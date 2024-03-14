import 'package:flutter/material.dart';
import 'package:flutter_app_familia/routes/app_router.dart';
import 'package:flutter_app_familia/themes/app_theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main()async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Usar las variables de entorno para la autenticación
  await signIn(dotenv.env['EMAIL']!, dotenv.env['PASSWORD']!);
  runApp(const ProviderScope(child:  MainApp()));
}
Future<void> signIn(String email, String password) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
  } catch (e) {
    print("Error credenciales: $email | $password");
    print("Error al iniciar sesión: $e");
  }
}
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'App Familia',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: AppTheme().getTheme(),
    );
  }
}