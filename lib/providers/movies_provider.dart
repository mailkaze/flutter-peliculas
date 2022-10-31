import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_peliculas/helpers/debouncer.dart';
import 'package:flutter_peliculas/models/models.dart';
import 'package:flutter_peliculas/models/search_response.dart';

class MoviesProvider extends ChangeNotifier {
  String _apiKey = 'b5b72fd56d635b01367976dd0ef04121';
  String _baseUrl = 'api.themoviedb.org';
  String _language = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];
  int _popularPage = 0;

  Map<int, List<Cast>> moviesCast = {};

  final debouncer = Debouncer(duration: const Duration(milliseconds: 500));

  final StreamController<List<Movie>> _suggestionsStreamController =
      StreamController.broadcast();
  Stream<List<Movie>> get suggestionsStream =>
      _suggestionsStreamController.stream;

  MoviesProvider() {
    // llamo los metodos en el constructor de su misma clase
    getNowPlayingMovies();
    getPopularMovies();
  }

  // la página es opcional y su valor por defecto es 1
  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    final url = Uri.https(_baseUrl, endpoint, {
      'api_key': _apiKey,
      'language': _language,
      'page': '$page',
    });

    final response = await http.get(url);

    if (response.statusCode != 200) print('error');

    return response.body;
  }

  getNowPlayingMovies() async {
    final jsonData = await _getJsonData('3/movie/now_playing');

    // usamos https://app.quicktype.io/ para convertir la respuesta en JSON a una clase de Dart
    // al convertir la respuesta en una instacia de una clase nuestra, podemos acceder a su
    // información de manera mucho más facil y con sugerencias de todo tipo
    final nowPlayingresponse = NowPlayingResponse.fromJson(jsonData);

    onDisplayMovies = nowPlayingresponse.results;

    // avisa a los listeners para re-renderizar
    notifyListeners();
  }

  getPopularMovies() async {
    _popularPage++;

    final jsonData = await _getJsonData('3/movie/popular', _popularPage);

    final popularResponse = PopularResponse.fromJson(jsonData);

    // para seguir cargando sin borrar las que ya tenia descargadas
    popularMovies = [...popularMovies, ...popularResponse.results];

    // avisa a los listeners para re-renderizar
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    // primero busca en el map a ver si ya los habiamos traído y no hace falta
    // volver a pedirlos
    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;

    // si no lo tenemos, lo pedimos de la API y lo guardamos en nuestro map
    final jsonData = await _getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonData);

    moviesCast[movieId] = creditsResponse.cast;

    return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovie(String query) async {
    final url = Uri.https(_baseUrl, '3/search/movie', {
      'api_key': _apiKey,
      'language': _language,
      'query': query,
    });

    final response = await http.get(url);

    final searchResponse = SearchResponse.fromJson(response.body);

    return searchResponse.results;
  }

  void getSuggestionsByQuery(String searchTerm) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final results = await searchMovie(value);
      _suggestionsStreamController.add(results);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      debouncer.value = searchTerm;
    });

    Future.delayed(const Duration(milliseconds: 301))
        .then((_) => timer.cancel());
  }
}
