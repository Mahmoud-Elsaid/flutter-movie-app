part of 'now_playing_tap_cubit.dart';

@immutable
sealed class NowPlayingTapState {}

final class NowPlayingTapInitial extends NowPlayingTapState {}
final class NowPlayingTapLoading extends NowPlayingTapState {}
final class NowPlayingTapSuccess extends NowPlayingTapState {
  final NowplayTapResponse nowPlayTapres;
  NowPlayingTapSuccess(this.nowPlayTapres);

}
final class NowPlayingTapFalure extends NowPlayingTapState {
   final String faild;
  NowPlayingTapFalure({required this.faild});
}
