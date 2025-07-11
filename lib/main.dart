import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:projeto_dio_viacep/pages/home_page.dart';
import 'package:projeto_dio_viacep/pages/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<bool> _initializeParse() async {
    WidgetsFlutterBinding.ensureInitialized();
    const keyApplicationId = 'IUqhu2TrOXixumUCkrff4EhP4vE8XL5csbMSDiFx';
    const keyClientKey = 'qMGcg58mppOlwUSE63V0pAhLoldeQCuq8uEzidWP';
    const keyParseServerUrl = 'https://parseapi.back4app.com';

    await Parse().initialize(
      keyApplicationId,
      keyParseServerUrl,
      clientKey: keyClientKey,
      autoSendSessionId: true,
      debug: true,
    );

    final response = await Parse().healthCheck();
    return response.success;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Consulta CEP',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[50],
        textTheme: GoogleFonts.poppinsTextTheme(textTheme),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      home: FutureBuilder<bool>(
        future: _initializeParse(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          if (snapshot.hasError || (snapshot.hasData && !snapshot.data!)) {
            final error =
                snapshot.error?.toString() ??
                "Falha na verificação de saúde do servidor. Verifique as chaves e a conexão.";
            return Scaffold(
              backgroundColor: Colors.red[700],
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Falha na conexão com o servidor.\n\nErro: $error',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }
          return const HomeScreen();
        },
      ),
    );
  }
}
