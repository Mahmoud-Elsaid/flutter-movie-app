import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_app/features/home/presentation/controller/cubits/upcoming_cubit/cubit/upcoming_model.dart';

part 'upcoming_state.dart';

class UpcomingCubit extends Cubit<UpcomingState> {
  UpcomingCubit() : super(UpcomingInitial());

  Future<void> getUpComingMovies() async {
    emit(UpcomingLoading());
    try {
      var dio = Dio();
      var res = await dio.get(
        'https://api.themoviedb.org/3/movie/upcoming',
        options: Options(
          headers: {
            "Authorization":
                "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwM2JiMGFkNmVhZjkxNzQ0NThmNjM3YzAyMTdhZDNiZiIsIm5iZiI6MTc2MTM5NzQwNS43NjEsInN1YiI6IjY4ZmNjYTlkM2I4MTI2ZTYyMjI3NTk1MyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.0Q8LMMsmjZZXqYz8Bta6IQNgM9pYXasxrDtkOeEW060",
            "accept": "application/json",
          },
        ),
      );
      var upComingData = UpComingModel.fromJson(res.data);
      if (kDebugMode) {
        print("UpComing ==============> ${res.data}");
      }
      emit(UpcomingSuccess(upComingData));
    } catch (e, stackTrace) {
      if (e is TypeError) {
        if (kDebugMode) {
          print(stackTrace);
        }
      }
      if (kDebugMode) {
        print('$e');
      }
    }
  }
}
