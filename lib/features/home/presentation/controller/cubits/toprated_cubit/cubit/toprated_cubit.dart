import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_app/features/home/presentation/controller/cubits/toprated_cubit/cubit/toprated_model.dart';

part 'toprated_state.dart';

class TopratedCubit extends Cubit<TopratedState> {
  TopratedCubit() : super(TopratedInitial());

  Future<void> getTopRatedMovies() async {
    emit(TopratedLoading());
    try {
      var dio=Dio();
      var res=await dio.get('https://api.themoviedb.org/3/movie/top_rated',
      options: Options(
        headers: {
          "Authorization":"Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwM2JiMGFkNmVhZjkxNzQ0NThmNjM3YzAyMTdhZDNiZiIsIm5iZiI6MTc2MTM5NzQwNS43NjEsInN1YiI6IjY4ZmNjYTlkM2I4MTI2ZTYyMjI3NTk1MyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.0Q8LMMsmjZZXqYz8Bta6IQNgM9pYXasxrDtkOeEW060",
          "accept":"application/json",
        }
      )
      );
      var topRatedData=TopRatedModel.fromJson(res.data);
      if (kDebugMode) {
        print("TopRated ==============> ${res.data}");
      }
      emit(TopratedSuccess(topRatedData));
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
