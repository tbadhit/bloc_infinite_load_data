import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_increment/bloc/infinite_load_bloc.dart';
import 'package:flutter_bloc_increment/model/photo_model.dart';
import 'package:flutter_bloc_increment/widgets/photo_item.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late InfiniteLoadBloc _bloc;
  int? _currentLength;
  List<PhotosModel> _data = [];

  void _loadMoreData() {
    _bloc.add(GetMoreInfiniteLoad(start: _currentLength, limit: 10));
  }

  @override
  void initState() {
    _bloc = BlocProvider.of<InfiniteLoadBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Infinite Load ScrollView"),
      ),
      body: BlocBuilder<InfiniteLoadBloc, InfiniteLoadState>(
        builder: (context, state) {
          if (state is InfiniteLoadLoaded || state is InfiniteLoadMoreLoading) {
            if (state is InfiniteLoadLoaded) {
              _data = state.data;
              _currentLength = state.count;
            }
            return _buildListPhotos(state);
          } else if (state is InfiniteLoadLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Text("Error");
          }
        },
      ),
    );
  }

  Widget _buildListPhotos(InfiniteLoadState state) {
    return LazyLoadScrollView(
        child: ListView(
          children: [
            ListView.builder(
                shrinkWrap: true,
                itemCount: _data.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (_, index) {
                  return PhotoItem(data: _data[index]);
                }),
            (state is InfiniteLoadMoreLoading)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SizedBox()
          ],
        ),
        onEndOfPage: _loadMoreData);
  }
}
