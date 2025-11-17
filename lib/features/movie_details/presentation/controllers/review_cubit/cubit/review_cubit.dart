import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:movie_app/features/movie_details/presentation/controllers/review_cubit/cubit/review_model.dart';

part 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  ReviewCubit() : super(ReviewInitial());

  Future <void> getReviews(String movieId) async{
    emit(ReviewLoading());
    try{
      var dio=Dio();
      var res=await dio.get("https://api.themoviedb.org/3/movie/$movieId/reviews",
      options: Options(
        headers: {
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjMTMzZDJiZTNiYmZiMTE5MTY1YjczMDg1YTQxYmVlYyIsIm5iZiI6MTc2MTM5NzgyNS4xOTkwMDAxLCJzdWIiOiI2OGZjY2M0MWNjM2VjMTVkYTU5ZmE5NGMiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.TfPH2Dk1Cfz5oQXj16wmbml0sS5BvmOmyEXRP5JO1kY",
          "accept":"application/json",
          "Content-Type":"application/json",
        }
      )
      );
      var data=MovieReviewsResponse.fromJson(res.data);
      emit(ReviewSuccess(reviews: data.results ?? []));
    }catch(e){
      emit(ReviewFailure(error: e.toString()));
    }

  }
}
