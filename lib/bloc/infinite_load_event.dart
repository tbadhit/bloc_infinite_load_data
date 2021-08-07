part of 'infinite_load_bloc.dart';

abstract class InfiniteLoadEvent extends Equatable {
  const InfiniteLoadEvent();

  @override
  List<Object> get props => [];
}

class GetInfiniteLoad extends InfiniteLoadEvent {}

class GetMoreInfiniteLoad extends InfiniteLoadEvent {
  final int? start;
  final int limit;

  GetMoreInfiniteLoad({required this.start, required this.limit});

  @override
  List<Object> get props => [start!, limit];
}
