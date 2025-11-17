part of 'toprated_cubit.dart';

@immutable
sealed class TopratedState {}

final class TopratedInitial extends TopratedState {}

final class TopratedLoading extends TopratedState {}

final class TopratedSuccess extends TopratedState {
  final TopRatedModel topRatedRes;

  TopratedSuccess(this.topRatedRes);
}

final class TopratedFalure extends TopratedState {}
