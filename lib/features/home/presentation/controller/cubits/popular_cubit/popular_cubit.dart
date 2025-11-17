import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_app/features/home/presentation/controller/cubits/popular_cubit/popular_model.dart';

part 'popular_cubit_state.dart';

class PopularCubit extends Cubit<PopularCubitState> {
  PopularCubit() : super(PopularCubitInitial());

  Future<void> getPopularMovies() async {
    emit(PopularLoading());
    try {
      var dio = Dio();
      var res = await dio.get(
        'https://api.themoviedb.org/3/movie/popular?language=en-US&page=1',
        options: Options(
          headers: {
            "Authorization":
                "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwM2JiMGFkNmVhZjkxNzQ0NThmNjM3YzAyMTdhZDNiZiIsIm5iZiI6MTc2MTM5NzQwNS43NjEsInN1YiI6IjY4ZmNjYTlkM2I4MTI2ZTYyMjI3NTk1MyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.0Q8LMMsmjZZXqYz8Bta6IQNgM9pYXasxrDtkOeEW060",
            "accept": "application/json",
          },
        ),
      );
      var data = PopularMovieResponse.fromJson(res.data);
      if (kDebugMode) {
        print("popular ==============> ${res.data}");
      }

      emit(PopularSuccess(data));
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
