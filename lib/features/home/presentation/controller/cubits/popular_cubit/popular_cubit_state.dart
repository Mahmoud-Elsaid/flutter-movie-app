part of 'popular_cubit.dart';

@immutable
sealed class PopularCubitState {

}

final class PopularCubitInitial extends PopularCubitState {
  
}

final class PopularLoading extends PopularCubitState {}
final class PopularSuccess extends PopularCubitState{
  final PopularMovieResponse populars;
  PopularSuccess(this.populars);

  get nowPlayingRes => null;
}
