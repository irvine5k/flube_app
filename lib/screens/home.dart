import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flube/blocs/favorite_bloc.dart';
import 'package:flube/blocs/videos_bloc.dart';
import 'package:flube/delegates/data_search.dart';
import 'package:flube/models/video.dart';
import 'package:flube/screens/favorites.dart';
import 'package:flube/widgets/video_tile.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final videosBloc = BlocProvider.of<VideosBloc>(context);
    final favBloc = BlocProvider.of<FavoriteBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Container(
              height: 40,
              child: Image.asset("images/logo.png"),
            ),
            SizedBox(width: 6),
            Text(
              'Flube',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.black87,
        actions: <Widget>[
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<Map<String, Video>>(
              stream: favBloc.outFav,
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return Text("${snapshot.data.length}");
                else
                  return Container();
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.star),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Favorites()));
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              String result =
                  await showSearch(context: context, delegate: DataSearch());
              if (result != null) videosBloc.inSearch.add(result);
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: StreamBuilder(
        stream: videosBloc.outVideos,
        initialData: [],
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return ListView.builder(
              itemBuilder: (context, index) {
                if (index < snapshot.data.length) {
                  return VideoTile(snapshot.data[index]);
                } else if (index > 1) {
                  videosBloc.inSearch.add(null);
                  return Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                    ),
                  );
                } else {
                  return Container();
                }
              },
              itemCount: snapshot.data.length + 1,
            );
          else
            return Container();
        },
      ),
    );
  }
}
