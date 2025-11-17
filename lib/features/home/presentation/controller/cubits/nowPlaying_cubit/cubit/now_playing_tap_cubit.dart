import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_app/features/home/presentation/controller/cubits/nowPlaying_cubit/cubit/now_playingtap_model.dart';

part 'now_playing_tap_state.dart';

class NowPlayingTapCubit extends Cubit<NowPlayingTapState> {
  NowPlayingTapCubit() : super(NowPlayingTapInitial());
  Future<void> getNowPlayingTap() async {
    emit(NowPlayingTapLoading());
    try {
      var dio = Dio();
      var onPlayRes = await dio.get(
        'https://api.themoviedb.org/3/movie/popular?language=en-US&page=1',
        options: Options(
          headers: {
            "Authorization":
                "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwM2JiMGFkNmVhZjkxNzQ0NThmNjM3YzAyMTdhZDNiZiIsIm5iZiI6MTc2MTM5NzQwNS43NjEsInN1YiI6IjY4ZmNjYTlkM2I4MTI2ZTYyMjI3NTk1MyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.0Q8LMMsmjZZXqYz8Bta6IQNgM9pYXasxrDtkOeEW060",
            "accept": "application/json",
          },
        ),
      );
      var onPlayTapData = NowplayTapResponse.fromJson(onPlayRes.data);
      if (kDebugMode) {
        print("Now_Playing ==============> ${onPlayRes.data}");
      }
      emit(NowPlayingTapSuccess(onPlayTapData));
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
