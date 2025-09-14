import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Intro Flutter',
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String title = 'Hola, Flutter';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Container con márgenes, color y borde alrededor del texto
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Estudiante: Alejandro Gutierrez',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.network('https://lamoto.com.ar/wp-content/uploads/2020/08/bmw-s1000-3.jpeg', width: 100, height: 100,),
                // Reemplaza por tu asset local, asegúrate de tener la imagen en assets y declarada en pubspec.yaml
                Image.network('https://upload.wikimedia.org/wikipedia/commons/thumb/4/4f/Kawasaki_Ninja_H2.jpg/1200px-Kawasaki_Ninja_H2.jpg', width: 100, height: 100),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  title = (title == 'Hola, Flutter')
                      ? '¡Título cambiado!'
                      : 'Hola, Flutter';
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Título actualizado')),
                );
              },
              child: const Text('Cambiar título'),
            ),
            const SizedBox(height: 24),
            // ListView de 4 elementos con icono y texto
            const Text(
              'Lista de elementos:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(
              height: 140, // Altura fija para ListView
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.motorcycle, color: Colors.blue),
                    title: Text('Moto BMW S1000'),
                  ),
                  ListTile(
                    leading: Icon(Icons.motorcycle, color: Colors.green),
                    title: Text('Moto Kawasaki H2'),
                  ),
                  ListTile(
                    leading: Icon(Icons.star, color: Colors.orange),
                    title: Text('Favorita'),
                  ),
                  ListTile(
                    leading: Icon(Icons.person, color: Colors.purple),
                    title: Text('Estudiante'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
