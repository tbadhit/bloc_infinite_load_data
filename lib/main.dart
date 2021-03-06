import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_increment/bloc/infinite_load_bloc.dart';
import 'package:flutter_bloc_increment/pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<InfiniteLoadBloc>(
        create: (context) => InfiniteLoadBloc()..add(GetInfiniteLoad()),
        child: HomePage(),
      ),
    );
  }
}
