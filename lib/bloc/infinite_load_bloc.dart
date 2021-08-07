import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc_increment/model/photo_model.dart';
import 'package:flutter_bloc_increment/services/photo_services.dart';

part 'infinite_load_event.dart';
part 'infinite_load_state.dart';

class InfiniteLoadBloc extends Bloc<InfiniteLoadEvent, InfiniteLoadState> {
  InfiniteLoadBloc() : super(InfiniteLoadInitial());

  PhotoServices _photoServices = PhotoServices();
  List<PhotosModel> _data = [];

  int? _currentLength;
  bool? _isLastPage;

  // Pada override method ini ini untuk menentukan/menghandle transition per event di Bloc.
  @override
  Stream<Transition<InfiniteLoadEvent, InfiniteLoadState>> transformEvents(
      Stream<InfiniteLoadEvent> events,
      TransitionFunction<InfiniteLoadEvent, InfiniteLoadState> transitionFn) {
    return super.transformEvents(
        events.debounceTime(Duration(milliseconds: 500)), transitionFn);
  }

  @override
  Stream<InfiniteLoadState> mapEventToState(
    InfiniteLoadEvent event,
  ) async* {
    if (event is GetInfiniteLoad) {
      yield* _mapEventToStateInfiniteLoad(start: 10);
    } else if (event is GetMoreInfiniteLoad) {
      yield* _mapEventToStateInfiniteLoad(
          start: event.start, limit: event.limit);
    }
  }

  Stream<InfiniteLoadState> _mapEventToStateInfiniteLoad(
      {required int? start, int? limit}) async* {
    try {
      if (state is InfiniteLoadLoaded) {
        _data = (state as InfiniteLoadLoaded).data;
        _currentLength = (state as InfiniteLoadLoaded).count;
      }

      if (_currentLength != null) {
        yield InfiniteLoadMoreLoading();
      } else {
        yield InfiniteLoadLoading();
      }

      if (_currentLength == null || _isLastPage == null || !_isLastPage!) {
        final reqData =
            await _photoServices.getPhoto(start: start, limit: limit);

        if (reqData!.isNotEmpty) {
          _data.addAll(reqData);
          if (_currentLength != null) {
            _currentLength = _currentLength! + reqData.length;
          } else {
            _currentLength = reqData.length;
          }
        } else {
          _isLastPage = true;
        }
        yield InfiniteLoadLoaded(data: _data, count: _currentLength);
      }
    } catch (e) {
      yield InfiniteLoadError();
    }
  }
}
