import 'package:flutter/material.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const TallerHttpApp());
}

class TallerHttpApp extends StatelessWidget {
  const TallerHttpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Taller HTTP - Chuck Norris Jokes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      ),
      routerConfig: AppRoutes.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
