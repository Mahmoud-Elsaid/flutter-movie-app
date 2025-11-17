part of 'movie_details_cubit.dart';

@immutable
sealed class MovieDetailsState {}

final class MovieDetailsInitial extends MovieDetailsState {}
final class MovieDetailsLoading extends MovieDetailsState {}
final class MovieDetailsSuccess extends MovieDetailsState {
  final MovieDetailsModel moviesdetails;

  MovieDetailsSuccess({required this.moviesdetails});
  
}
final class MovieDetailsFalure extends MovieDetailsState {
  final String falureMessage;

  MovieDetailsFalure({required this.falureMessage});
  
}
