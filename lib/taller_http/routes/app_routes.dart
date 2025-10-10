import 'package:go_router/go_router.dart';
import '../views/jokes/jokes_list_view.dart';
import '../views/jokes/joke_detail_view.dart';

class AppRoutes {
  static const String jokesListRoute = '/';
  static const String jokeDetailRoute = '/joke/:id';

  static final GoRouter router = GoRouter(
    initialLocation: jokesListRoute,
    routes: [
      GoRoute(
        path: jokesListRoute,
        name: 'jokes_list',
        builder: (context, state) => const JokesListView(),
      ),
      GoRoute(
        path: jokeDetailRoute,
        name: 'joke_detail',
        builder: (context, state) {
          final String jokeId = state.pathParameters['id'] ?? '';
          final String jokeText = state.uri.queryParameters['text'] ?? '';
          final String category = state.uri.queryParameters['category'] ?? '';

          return JokeDetailView(
            jokeId: jokeId,
            jokeText: jokeText,
            category: category,
          );
        },
      ),
    ],
  );
}
