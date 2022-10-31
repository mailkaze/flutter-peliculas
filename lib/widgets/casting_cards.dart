import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_peliculas/models/models.dart';
import 'package:flutter_peliculas/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class CastingCards extends StatelessWidget {
  final int movieId;

  const CastingCards({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    // no es necesario re-renderizar este widget y volver a llamar al provider
    // por eso listen se pone en false
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
      future: moviesProvider.getMovieCast(movieId),
      builder: (_, AsyncSnapshot<List<Cast>> snapshot) {
        // si el future aun no devolvió los datos de la API
        if (!snapshot.hasData) {
          return Container(
            constraints: BoxConstraints(maxWidth: 150),
            margin: EdgeInsets.only(bottom: 30),
            width: double.infinity,
            height: 180,
            child: CupertinoActivityIndicator(),
          );
        }

        final cast = snapshot.data!;

        // si hay datos desde el provider:
        return Container(
          margin: EdgeInsets.only(bottom: 30),
          width: double.infinity,
          height: 220,
          // color: Colors.red,
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (_, index) => _CastCard(actor: cast[index]),
            scrollDirection: Axis.horizontal,
          ),
        );
      },
    );
  }
}

class _CastCard extends StatelessWidget {
  final Cast actor;

  const _CastCard({super.key, required this.actor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 100,
      // color: Colors.green,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: AssetImage('assets/no-image.jpg'),
              image: NetworkImage(actor.fullProfilePath),
              width: 100,
              height: 140,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            actor.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          Text(
            actor.character ?? '',
            style: TextStyle(color: Colors.black38),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
