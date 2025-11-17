import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_app/features/home/presentation/controller/cubits/movies_cubit/movie_response_model.dart';
part 'now_playing_state.dart';

class NowPlayingCubit extends Cubit<NowPlayingState> {
  NowPlayingCubit() : super(NowPlayingInitial());

  Future<MoviesResponse> getNowPlaying() async {
    emit(NowPlayingLoading());
    var dio = Dio();
    try {
      var res = await dio.get(
        'https://api.themoviedb.org/3/movie/now_playing?language=en-US&page=1',
        options: Options(
          headers: {
            "Authorization":
                "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwM2JiMGFkNmVhZjkxNzQ0NThmNjM3YzAyMTdhZDNiZiIsIm5iZiI6MTc2MTM5NzQwNS43NjEsInN1YiI6IjY4ZmNjYTlkM2I4MTI2ZTYyMjI3NTk1MyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.0Q8LMMsmjZZXqYz8Bta6IQNgM9pYXasxrDtkOeEW060",
            "accept": "application/json",
          },
        ),
      );
      final moviesResponse = MoviesResponse.fromJson(res.data);
      emit(NowPlayingSuccess(result: moviesResponse));
      return moviesResponse;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(NowPlayingFalure(faild: e.toString()));
      rethrow;
    }
  }
}
