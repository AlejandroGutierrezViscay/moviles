import 'package:go_router/go_router.dart';
import 'package:moviles/taller_segundo_plano/views/async/async_demo_screen.dart';
import 'package:moviles/taller_segundo_plano/views/ciclo_vida/ciclo_vida_screen.dart';
import 'package:moviles/taller_segundo_plano/views/paso_parametros/detalle_screen.dart';
import 'package:moviles/taller_segundo_plano/views/paso_parametros/paso_parametros_screen.dart';
import 'package:moviles/taller_segundo_plano/views/demo/demo_screen.dart';
import 'package:moviles/taller_segundo_plano/views/timer/timer_screen.dart';

import '../views/future/future_view.dart';
import '../views/home/home_screen.dart';
import '../views/isolate/isolate_view.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(), // Usa HomeView
    ),
    // Demo screen que integra Future / Timer / Isolate
    GoRoute(
      path: '/demo',
      name: 'demo',
      builder: (context, state) => const DemoScreen(),
    ),
    // Ruta para el cronómetro
    GoRoute(
      path: '/timer',
      name: 'timer',
      builder: (context, state) => const TimerScreen(),
    ),
    // Ruta para la demo de async/await
    GoRoute(
      path: '/async',
      name: 'async',
      builder: (context, state) => const AsyncDemoScreen(),
    ),
    // Rutas para el paso de parámetros
    GoRoute(
      path: '/paso_parametros',
      name: 'paso_parametros',
      builder: (context, state) => const PasoParametrosScreen(),
    ),

    // !Ruta para el detalle con parámetros
    GoRoute(
      path:
          '/detalle/:parametro/:metodo', //la ruta recibe dos parametros los " : " indican que son parametros
      builder: (context, state) {
        //*se capturan los parametros recibidos
        // declarando las variables parametro y metodo
        // es final porque no se van a modificar
        final parametro = state.pathParameters['parametro']!;
        final metodo = state.pathParameters['metodo']!;
        return DetalleScreen(parametro: parametro, metodoNavegacion: metodo);
      },
    ),
    //!Ruta para el ciclo de vida
    GoRoute(
      path: '/ciclo_vida',
      builder: (context, state) => const CicloVidaScreen(),
    ),
    //!Ruta para FUTURE
    GoRoute(
      path: '/future',
      name: 'future',
      builder: (context, state) => const FutureView(),
    ),
    //!Ruta para ISOLATE
    GoRoute(
      path: '/isolate',
      name: 'isolate',
      builder: (context, state) => const IsolateView(),
    ),
  ],
);
