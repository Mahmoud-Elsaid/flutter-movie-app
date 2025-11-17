import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:movie_app/features/movie_details/presentation/controllers/details_cubit/movie_details_model.dart';

part 'movie_details_state.dart';

class MovieDetailsCubit extends Cubit<MovieDetailsState> {
  MovieDetailsCubit() : super(MovieDetailsInitial());
  void refreshUi() {
    emit(MovieDetailsInitial());
  }

  Future<void> getDetails(String id) async {
    emit(MovieDetailsLoading());
    try {
      var dio = Dio();
      Response res = await dio.get(
        "https://api.themoviedb.org/3/movie/$id",
        options: Options(
          headers: {
            "Authorization":
                "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjMTMzZDJiZTNiYmZiMTE5MTY1YjczMDg1YTQxYmVlYyIsIm5iZiI6MTc2MTM5NzgyNS4xOTkwMDAxLCJzdWIiOiI2OGZjY2M0MWNjM2VjMTVkYTU5ZmE5NGMiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.TfPH2Dk1Cfz5oQXj16wmbml0sS5BvmOmyEXRP5JO1kY",
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
        ),
      );
      var data = MovieDetailsModel.fromJson(res.data);
      emit(MovieDetailsSuccess(moviesdetails: data));
    } catch (e) {
      emit(MovieDetailsFalure(falureMessage: e.toString()));
    }
  }
}
