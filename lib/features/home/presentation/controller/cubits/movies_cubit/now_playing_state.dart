part of 'now_playing_cubit.dart';

@immutable
sealed class NowPlayingState {}

final class NowPlayingInitial extends NowPlayingState {}
final class NowPlayingLoading extends NowPlayingState {}
final class NowPlayingSuccess extends NowPlayingState {
  final MoviesResponse result;

  NowPlayingSuccess({required this.result});
}
final class NowPlayingFalure extends NowPlayingState {
  final String faild;

  NowPlayingFalure({required this.faild});
  
}

