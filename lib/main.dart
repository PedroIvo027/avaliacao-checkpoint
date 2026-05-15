import 'package:flutter/material.dart';
import 'package:projeto_usedev/src/screens/initial_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // Garante a comunicação com o sistema nativo antes do Firebase ligar
  WidgetsFlutterBinding.ensureInitialized();
  
  // Liga o motor do Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UseDev',
      theme: ThemeData(
        // Corrigido: adicionado 'ColorScheme' antes do '.fromSeed'
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const InitialScreen(),
    );
  }
}