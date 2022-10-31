import 'package:flutter/material.dart';
import 'package:flutter_peliculas/models/models.dart';
import 'package:flutter_peliculas/widgets/widgets.dart';

class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Movie movie = ModalRoute.of(context)?.settings.arguments! as Movie;

    return Scaffold(
      body: CustomScrollView(slivers: [
        _CustomAppBar(
          backdrop: movie.fullBackdropPath,
          title: movie.title,
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            _PosterAndTitle(
              movieId: movie.heroId!,
              poster: movie.fullPosterImg,
              title: movie.title,
              originalTitle: movie.originalTitle,
              voteAverage: movie.voteAverage,
            ),
            _Overview(
              overview: movie.overview,
            ),
            _Overview(
              overview: movie.overview,
            ),
            _Overview(
              overview: movie.overview,
            ),
            CastingCards(
              movieId: movie.id,
            ),
          ]),
        )
      ]),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  final String backdrop;
  final String title;

  const _CustomAppBar({super.key, required this.backdrop, required this.title});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.indigo,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: EdgeInsets.all(0),
        title: Container(
            padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
            width: double.infinity,
            alignment: Alignment.bottomCenter,
            color: Colors.black12,
            child: Text(
              title,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            )),
        background: FadeInImage(
          placeholder: AssetImage('assets/loading.gif'),
          // image: AssetImage('assets/loading.gif'),
          image: NetworkImage(backdrop),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  final String movieId;
  final String poster;
  final String title;
  final String originalTitle;
  final double voteAverage;

  const _PosterAndTitle(
      {super.key,
      required this.movieId,
      required this.poster,
      required this.title,
      required this.originalTitle,
      required this.voteAverage});
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Hero(
            tag: movieId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: AssetImage('assets/no-image.jpg'),
                image: NetworkImage(poster),
                height: 150,
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          ConstrainedBox(
              constraints: BoxConstraints(maxWidth: size.width - 190),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headline5,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Text(
                    originalTitle,
                    style: textTheme.subtitle1,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_outline,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        '$voteAverage',
                        style: textTheme.caption,
                      ),
                    ],
                  )
                ],
              ))
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  final String overview;

  const _Overview({required this.overview});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Text(
        overview,
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}
