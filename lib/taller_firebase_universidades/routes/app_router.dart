import 'package:go_router/go_router.dart';
import '../views/categoria_fb/categoria_fb_list_view.dart';
import '../views/categoria_fb/categoria_fb_from_view.dart';
import '../views/universidades/universidad_list_view.dart';
import '../views/universidades/universidad_form_view.dart';
import '../views/universidades/universidad_evidencia_view.dart';
import '../views/home/home_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    // Ruta principal
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),

    // Rutas de Categorías Firebase
    GoRoute(
      path: '/categoriasFirebase',
      name: 'categoriasFirebase',
      builder: (_, __) => const CategoriaFbListView(),
    ),
    GoRoute(
      path: '/categoriasfb/create',
      name: 'categoriasfb.create',
      builder: (context, state) => const CategoriaFbFormView(),
    ),
    GoRoute(
      path: '/categoriasfb/edit/:id',
      name: 'categoriasfb.edit',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return CategoriaFbFormView(id: id);
      },
    ),

    // Rutas de Universidades
    GoRoute(
      path: '/universidades',
      name: 'universidades',
      builder: (_, __) => const UniversidadListView(),
    ),
    GoRoute(
      path: '/universidades/create',
      name: 'universidades.create',
      builder: (context, state) => const UniversidadFormView(),
    ),
    GoRoute(
      path: '/universidades/edit/:id',
      name: 'universidades.edit',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return UniversidadFormView(id: id);
      },
    ),
    GoRoute(
      path: '/universidades/evidencia',
      name: 'universidades.evidencia',
      builder: (_, __) => const UniversidadEvidenciaView(),
    ),
  ],
);
