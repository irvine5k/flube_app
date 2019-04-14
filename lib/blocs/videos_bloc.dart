import 'package:flube/models/video.dart';
import 'package:flube/api.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'dart:async';

class VideosBloc implements BlocBase {
  Api api;

  List<Video> videos;

  final StreamController<List<Video>> _videosController =
      StreamController<List<Video>>();
  // Output of videos controller from out of this bloc
  Stream get outVideos => _videosController.stream;

  final StreamController<String> _searchController = StreamController<String>();
  // Input of search controller from out of this bloc
  Sink get inSearch => _searchController.sink;

  VideosBloc() {
    api = Api();

    // Search controller will listen the input of data from the function search
    _searchController.stream.listen(_search);
  }

  // Call search method on api and return the videos
  void _search(String search) async {
    // If search is null do a search otherwise add videos of next page to our list of videos
    if (search != null) {
      _videosController.sink.add([]);
      videos = await api.search(search);
    } else {
      videos += await api.nextPage();
    }

    _videosController.sink.add(videos);
  }

  @override
  void dispose() {
    // Closing the streams
    _videosController.close();
    _searchController.close();
  }
}
