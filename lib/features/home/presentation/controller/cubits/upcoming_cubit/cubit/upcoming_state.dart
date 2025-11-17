part of 'upcoming_cubit.dart';

@immutable
sealed class UpcomingState {}

final class UpcomingInitial extends UpcomingState {}

final class UpcomingLoading extends UpcomingState {}

final class UpcomingSuccess extends UpcomingState {
  final UpComingModel upComingRes;

  UpcomingSuccess(this.upComingRes);
  
}

final class UpcomingFalure extends UpcomingState {}
