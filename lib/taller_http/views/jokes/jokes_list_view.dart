import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/chuck_norris_joke.dart';
import '../../services/chuck_norris_service.dart';
import '../../widgets/joke_card.dart';

class JokesListView extends StatefulWidget {
  const JokesListView({super.key});

  @override
  State<JokesListView> createState() => _JokesListViewState();
}

class _JokesListViewState extends State<JokesListView> {
  List<ChuckNorrisJoke> jokes = [];
  bool isLoading = true;
  String? errorMessage;
  List<String> categories = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await _loadCategories();
    await _loadJokes();
  }

  Future<void> _loadCategories() async {
    try {
      final fetchedCategories = await ChuckNorrisService.getCategories();
      setState(() {
        categories = fetchedCategories;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar categorías: $e'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  Future<void> _loadJokes() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final fetchedJokes = await ChuckNorrisService.getMixedJokes();
      setState(() {
        jokes = fetchedJokes;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            action: SnackBarAction(label: 'Reintentar', onPressed: _loadJokes),
          ),
        );
      }
    }
  }

  Future<void> _loadJokesByCategory(String category) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final joke = await ChuckNorrisService.getRandomJokeByCategory(category);
      setState(() {
        jokes = [joke];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _navigateToJokeDetail(ChuckNorrisJoke joke) {
    context.pushNamed(
      'joke_detail',
      pathParameters: {'id': joke.id},
      queryParameters: {
        'text': joke.value,
        'category': joke.categories.isNotEmpty
            ? joke.categories.first
            : 'general',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Chuck Norris Jokes',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.sentiment_very_satisfied,
                    size: 80,
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: _loadJokes,
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Categorías',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: FilterChip(
                              label: const Text('Todos'),
                              onSelected: (selected) => _loadJokes(),
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.secondaryContainer,
                            ),
                          );
                        }

                        final category = categories[index - 1];
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: FilterChip(
                            label: Text(category),
                            onSelected: (selected) =>
                                _loadJokesByCategory(category),
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.secondaryContainer,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          if (isLoading)
            const SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Cargando chistes divertidos...'),
                  ],
                ),
              ),
            )
          else if (errorMessage != null)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    Text(
                      'Error al cargar los chistes',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      errorMessage!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadJokes,
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final joke = jokes[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: JokeCard(
                      joke: joke,
                      onTap: () => _navigateToJokeDetail(joke),
                    ),
                  );
                }, childCount: jokes.length),
              ),
            ),
        ],
      ),
    );
  }
}
