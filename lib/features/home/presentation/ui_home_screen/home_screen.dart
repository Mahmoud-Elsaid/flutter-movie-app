import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/theme/colors.dart';
import 'package:movie_app/features/home/presentation/component/custom_movie_image_cursore.dart';
import 'package:movie_app/features/home/presentation/component/custom_movie_image.dart';
import 'package:movie_app/features/home/presentation/component/custom_text.dart';
import 'package:movie_app/features/home/presentation/component/custom_textformfield_search.dart';
import 'package:movie_app/features/home/presentation/controller/cubits/movies_cubit/now_playing_cubit.dart';
import 'package:movie_app/features/home/presentation/controller/cubits/nowPlaying_cubit/cubit/now_playing_tap_cubit.dart';
import 'package:movie_app/features/home/presentation/controller/cubits/popular_cubit/popular_cubit.dart';
import 'package:movie_app/features/home/presentation/controller/cubits/toprated_cubit/cubit/toprated_cubit.dart';
import 'package:movie_app/features/home/presentation/controller/cubits/upcoming_cubit/cubit/upcoming_cubit.dart';
import 'package:movie_app/features/movie_details/presentation/ui_detals_screen/movie_details.dart';
import 'package:movie_app/features/search/controllers/cubit/search_cubit.dart';
import 'package:movie_app/features/search/presentation/search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PopularCubit()..getPopularMovies()),
        BlocProvider(
          create: (context) => NowPlayingTapCubit()..getNowPlayingTap(),
        ),
        BlocProvider(create: (context) => UpcomingCubit()..getUpComingMovies()),
        BlocProvider(create: (context) => TopratedCubit()..getTopRatedMovies()),
      ],
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: CustomText(
            text: 'What do you want to watch?'.tr(),
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
            fontSize: 16,
          ),
          actions: [
            IconButton(
              onPressed: () {
                if (context.locale.languageCode == 'en') {
                  context.setLocale(const Locale('ar'));
                } else {
                  context.setLocale(const Locale('en'));
                }
              },
              icon: Icon(Icons.language, color: AppColors.textColor),
            ),
          ],
        ),
        body: DefaultTabController(
          length: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                CustomTextFormFieldSearch(
                  controller: searchController,
                  onFieldSubmitted: (value) {
                    if (value.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (_) => SearchCubit()..search(value),
                            child: SearchScreen(
                              query: value, // يمرر الكلمة اللي اتكتبت
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
                SizedBox(height: 20),
                BlocProvider(
                  create: (context) => NowPlayingCubit()..getNowPlaying(),
                  child: BlocConsumer<NowPlayingCubit, NowPlayingState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      if (state is NowPlayingLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state is NowPlayingSuccess) {
                        final movies = state.result;
                        return CarouselSlider.builder(
                          itemCount: movies.results?.length ?? 0,
                          itemBuilder: (context, index, realIndex) {
                            final movie = movies.results![index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        MovieDetails(movieId: movie.id ?? 0),
                                  ),
                                );
                              },
                              child: CustomCarouselMovieImage(
                                imageUrl: movie.posterPath ?? '',
                                index: index,
                                movieId: movie.id ?? 0,
                              ),
                            );
                          },
                          options: CarouselOptions(
                            viewportFraction: 0.4,
                            height: 200,
                            autoPlay: true,
                            enlargeCenterPage: true,
                          ),
                        );
                      }

                      if (state is NowPlayingFalure) {
                        return Center(child: Text(state.faild));
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.only(left: 3, right: 3),
                  child: TabBar(
                    tabs: [
                      Tab(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'now_playing'.tr(),
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'upcoming'.tr(),
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'top_rated'.tr(),
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'popular'.tr(),
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                    dividerHeight: 0,
                    indicatorColor: AppColors.textColor,
                    indicatorSize: TabBarIndicatorSize.label,
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      BlocBuilder<NowPlayingTapCubit, NowPlayingTapState>(
                        builder: (context, state) {
                          if (state is NowPlayingTapLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (state is NowPlayingTapSuccess) {
                            final movies = state.nowPlayTapres.results ?? [];

                            return GridView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount: movies.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                  ),
                              itemBuilder: (context, index) {
                                final movie = movies[index];

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => MovieDetails(
                                          movieId: movie.id ?? 0,
                                        ),
                                      ),
                                    );
                                  },
                                  child: CustomMovieImage(
                                    imageUrl: movie.posterPath ?? '',
                                  ),
                                );
                              },
                            );
                          }
                          if (state is NowPlayingTapFalure) {
                            return Center(
                              child: Text(
                                state.faild,
                                style: const TextStyle(color: Colors.red),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),

                      BlocBuilder<UpcomingCubit, UpcomingState>(
                        builder: (context, state) {
                          if (state is UpcomingLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (state is UpcomingSuccess) {
                            var data = state.upComingRes;
                            return GridView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount: data.results?.length ?? 0,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                  ),
                              itemBuilder: (context, index) {
                                final movie = data.results![index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => MovieDetails(
                                          movieId: movie.id ?? 0,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: CustomMovieImage(
                                      imageUrl: movie.posterPath ?? '',
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          return Container(color: AppColors.textColor);
                        },
                      ),

                      BlocBuilder<TopratedCubit, TopratedState>(
                        builder: (context, state) {
                          if (state is TopratedLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (state is TopratedSuccess) {
                            var data = state.topRatedRes;
                            return GridView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount: data.results?.length ?? 0,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                  ),
                              itemBuilder: (context, index) {
                                final movie = data.results![index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => MovieDetails(
                                          movieId: movie.id ?? 0,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: CustomMovieImage(
                                      imageUrl: movie.posterPath ?? '',
                                    ),
                                  ),
                                );
                              },
                            );
                          }

                          return Container(color: AppColors.textColor);
                        },
                      ),

                      BlocBuilder<PopularCubit, PopularCubitState>(
                        builder: (context, state) {
                          if (state is PopularLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (state is PopularSuccess) {
                            var data = state.populars;
                            return GridView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount: data.results?.length ?? 0,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                  ),
                              itemBuilder: (context, index) {
                                final movie = data.results![index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => MovieDetails(
                                          movieId: movie.id ?? 0,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: CustomMovieImage(
                                      imageUrl: movie.posterPath ?? '',
                                    ),
                                  ),
                                );
                              },
                            );
                          }

                          return Container(color: AppColors.textColor);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}






/*

 BlocBuilder<PopularCubit, PopularCubitState>(
                        builder: (context, state) {
                          if (state is PopularLoading) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (state is PopularSuccess) {
                            var data = state.populars;
                            return GridView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount: data.results?.length ?? 0,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                  ),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: CustomMovieImage(
                                    imageUrl:
                                        data.results?[index].posterPath ?? '',
                                  ),
                                );
                              },
                            );
                          }
                          return Container(color: AppColors.textColor);
                        },
                      ),

*/

/*
 BlocBuilder<TopratedCubit, TopratedState>(
                        builder: (context, state) {
                          if (state is TopratedLoading) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (state is TopratedSuccess) {
                            var data = state.topRatedRes;
                            return GridView.builder(
                              padding: EdgeInsets.all(8),
                              itemCount: data.results?.length ?? 0,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                  ),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: CustomMovieImage(
                                    imageUrl:
                                        data.results?[index].posterPath ?? '',
                                  ),
                                );
                              },
                            );
                          }
                          return Container(color: AppColors.textColor);
                        },
                      ),
 */

/*

 BlocBuilder<UpcomingCubit, UpcomingState>(
                        builder: (context, state) {
                          if (state is UpcomingLoading) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (state is UpcomingSuccess) {
                            var data = state.upComingRes;
                            return GridView.builder(
                              padding: EdgeInsets.all(8),
                              itemCount: data.results?.length ?? 0,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                  ),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: CustomMovieImage(
                                    imageUrl:
                                        data.results?[index].posterPath ?? '',
                                  ),
                                );
                              },
                            );
                          }
                          return Container(color: AppColors.textColor);
                        },
                      ),
 */

/*

 BlocBuilder<NowPlayingTapCubit, NowPlayingTapState>(
                        builder: (context, state) {
                          if (state is PopularLoading) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (state is NowPlayingTapSuccess) {
                            var data = state.nowPlayTapres;
                            return GridView.builder(
                              padding: EdgeInsets.all(8),
                              itemCount: data.results?.length ?? 0,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                  ),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: CustomMovieImage(
                                    imageUrl:
                                        data.results?[index].posterPath ?? '',
                                  ),
                                );
                              },
                            );
                          }
                          return Container(color: AppColors.textColor);
                        },
                      ),

 */

/*

 return GridView.builder(
                              padding: EdgeInsets.all(8),
                              itemCount: data.results?.length ?? 0,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                  ),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.network(
                                      "https://image.tmdb.org/t/p/w500///${data.results?[index].posterPath}",
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                );
                              },
                            );
 */

/*

 return CarouselSlider.builder(
                          itemCount: movies.results?.length,
                          itemBuilder: (context, index, realIndex) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      "https://image.tmdb.org/t/p/w500///${movies.results?[index].posterPath}",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: -15,
                                    left: 10,
                                    child: Stack(
                                      children: [
                                        Text(
                                          "${index + 1}",
                                          style: TextStyle(
                                            fontSize: 55,
                                            fontWeight: FontWeight.bold,
                                            foreground: Paint()
                                              ..style = PaintingStyle.stroke
                                              ..strokeWidth = 5
                                              ..color = Colors.blueGrey
                                                  .withOpacity(0.8),
                                          ),
                                        ),
                                        Text(
                                          "${index + 1}",
                                          style: TextStyle(
                                            fontSize: 55,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.numberscolor
                                                .withOpacity(0.9),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          options: CarouselOptions(
                            viewportFraction: 0.4,
                            height: 200,
                            autoPlay: true,
                            enlargeCenterPage: true,
                          ),
                        );

 */