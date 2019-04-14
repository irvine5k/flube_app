import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flube/blocs/favorite_bloc.dart';
import 'package:flube/blocs/videos_bloc.dart';
import 'package:flutter/material.dart';
import './screens/home.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        bloc: VideosBloc(),
        child: BlocProvider(
          bloc: FavoriteBloc(),
          child: MaterialApp(
            title: 'Flube',
            debugShowCheckedModeBanner: false,
            home: Home(),
          ),
        ));
  }
}
