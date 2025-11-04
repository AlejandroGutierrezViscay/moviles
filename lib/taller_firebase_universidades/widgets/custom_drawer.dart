import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Text(
              'Taller Firebase - Universidades',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () {
              context.go('/');
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.school),
            title: const Text('Universidades'),
            subtitle: const Text('Gestionar universidades'),
            onTap: () {
              context.pushNamed('universidades');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.science),
            title: const Text('Evidencia en Tiempo Real'),
            subtitle: const Text('Ver datos sincronizados'),
            onTap: () {
              context.pushNamed('universidades.evidencia');
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.cloud),
            title: const Text('Categorías Firebase'),
            subtitle: const Text('Demo categorías'),
            onTap: () {
              context.pushNamed('categoriasFirebase');
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text('Login'),
            onTap: () {
              context.go('/login');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_add),
            title: const Text('Registro'),
            onTap: () {
              context.go('/register');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Evidencia JWT'),
            onTap: () {
              context.go('/evidence');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
