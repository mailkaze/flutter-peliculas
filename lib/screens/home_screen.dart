import 'package:flutter/material.dart';
import 'package:flutter_peliculas/providers/movies_provider.dart';
import 'package:flutter_peliculas/search/search_delegate.dart';
import 'package:flutter_peliculas/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Películas en cines'),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: MovieSearchDelegate());
              },
              icon: const Icon(Icons.search_outlined))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CardSwipper(movies: moviesProvider.onDisplayMovies),
            MovieSlider(
              movies: moviesProvider.popularMovies,
              title: 'Populares!', // opcional
              onNextPage: () => moviesProvider.getPopularMovies(),
            ),
          ],
        ),
      ),
    );
  }
}
