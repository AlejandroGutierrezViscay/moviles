import 'package:flutter/material.dart';
import '../models/chuck_norris_joke.dart';

class JokeCard extends StatelessWidget {
  final ChuckNorrisJoke joke;
  final VoidCallback onTap;

  const JokeCard({super.key, required this.joke, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con categoría e ícono
              Row(
                children: [
                  if (joke.categories.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        joke.categories.first.toUpperCase(),
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSecondaryContainer,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const Spacer(),
                  Icon(Icons.chevron_right, color: Colors.grey[400]),
                ],
              ),

              const SizedBox(height: 12),

              // Texto del chiste
              Text(
                joke.value,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(height: 1.4),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              // Footer con información adicional
              Row(
                children: [
                  Icon(
                    Icons.sentiment_very_satisfied,
                    size: 16,
                    color: Colors.orange[700],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Chuck Norris',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${joke.value.length} chars',
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
