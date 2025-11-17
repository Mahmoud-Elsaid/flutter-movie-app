import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:movie_app/features/movie_details/presentation/controllers/cast_cublit/cubit/cast_model.dart';

part 'cast_state.dart';

class CastCubit extends Cubit<CastState> {
  CastCubit() : super(CastInitial());
  
  Future<void> getCast(String movieId)async {
    emit(CastLoading());
    try{
      var dio=Dio();
      var responseData=await dio.get("https://api.themoviedb.org/3/movie/$movieId/credits",options: Options(
        headers: {
          "Authorization":"Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjMTMzZDJiZTNiYmZiMTE5MTY1YjczMDg1YTQxYmVlYyIsIm5iZiI6MTc2MTM5NzgyNS4xOTkwMDAxLCJzdWIiOiI2OGZjY2M0MWNjM2VjMTVkYTU5ZmE5NGMiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.TfPH2Dk1Cfz5oQXj16wmbml0sS5BvmOmyEXRP5JO1kY",
          "accept":"application/json",
          "Content-Type":"application/json",
        }
      ));
       var data=CastModel.fromJson(responseData.data);
       emit(CastSuccess(data.cast ?? []));
    }catch(e){
      emit(CastFailure(e.toString()));
    }
  }
}
