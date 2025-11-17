import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:movie_app/core/theme/colors.dart';
import 'package:movie_app/features/home/presentation/component/custom_movie_image.dart';
import 'package:movie_app/features/home/presentation/component/custom_text.dart';
import 'package:movie_app/features/movie_details/presentation/component/custom_Review_List.dart';
import 'package:movie_app/features/movie_details/presentation/component/custom_cast_info.dart';
import 'package:movie_app/features/movie_details/presentation/component/custom_movie_info.dart';
import 'package:movie_app/features/movie_details/presentation/component/custom_poster_image.dart';
import 'package:movie_app/features/movie_details/presentation/controllers/cast_cublit/cubit/cast_cubit.dart';
import 'package:movie_app/features/movie_details/presentation/controllers/details_cubit/movie_details_cubit.dart';
import 'package:movie_app/features/movie_details/presentation/controllers/review_cubit/cubit/review_cubit.dart';

class MovieDetails extends StatelessWidget {
  final int movieId;
  const MovieDetails({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MovieDetailsCubit()..getDetails(movieId.toString()),
        ),
        BlocProvider(
          create: (_) => ReviewCubit()..getReviews(movieId.toString()),
        ),
        BlocProvider(create: (_) => CastCubit()..getCast(movieId.toString())),
      ],
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: AppColors.primaryColor,
          appBar: AppBar(
            backgroundColor: AppColors.primaryColor,
            iconTheme: const IconThemeData(color: Colors.white),
            title: Center(
              child: CustomText(
                text: "Details",
                fontWeight: FontWeight.w600,
                color: AppColors.textColor,
                fontSize: 16,
              ),
            ),
            actions: [
              BlocBuilder<MovieDetailsCubit, MovieDetailsState>(
                builder: (context, state) {
                  if (state is! MovieDetailsSuccess) {
                    return const SizedBox.shrink();
                  }

                  final movie = state.moviesdetails;
                  final box = Hive.box('watchlistBox');
                  final isFavorite = box.containsKey(movie.id);

                  return IconButton(
                    onPressed: () async {
                      if (isFavorite) {
                        await box.delete(movie.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Removed from Watchlist'),
                          ),
                        );
                      } else {
                        await box.put(movie.id, {
                          'id': movie.id,
                          'title': movie.title,
                          'poster_path': movie.posterPath,
                          'vote_average': movie.voteAverage,
                          'genre': movie.genres?.isNotEmpty == true
                              ? movie.genres!.first.name
                              : 'N/A',
                          'release_date': movie.releaseDate ?? 'N/A',
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added to Watchlist')),
                        );
                      }
                      (context as Element).markNeedsBuild();
                    },
                    icon: Icon(
                      isFavorite ? Icons.bookmark : Icons.bookmark_border,
                      color: isFavorite ? Colors.amber : AppColors.textColor,
                    ),
                  );
                },
              ),
            ],
          ),

          body: Column(
            children: [
              BlocBuilder<MovieDetailsCubit, MovieDetailsState>(
                builder: (context, state) {
                  if (state is MovieDetailsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is MovieDetailsSuccess) {
                    final movie = state.moviesdetails;
                    return SizedBox(
                      height: 250,
                      width: double.infinity,
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          Positioned.fill(
                            child: CustomMoviePosterDetails(
                              imageUrl:
                                  movie.backdropPath ?? movie.posterPath ?? '',
                            ),
                          ),

                          Positioned(
                            bottom: -50,
                            left: 20,
                            right: 20,
                            child: Row(
                              children: [
                                // الصورة الصغيرة
                                SizedBox(
                                  height: 130,
                                  width: 100,
                                  child: CustomMovieImage(
                                    imageUrl: movie.posterPath ?? '',
                                  ),
                                ),

                                const SizedBox(width: 10),

                                // الاسم جنب الصورة
                                Expanded(
                                  child: Transform.translate(
                                    offset: const Offset(0, 35),
                                    child: Text(
                                      movie.title ?? 'No Title',
                                      maxLines: 2,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Positioned(
                            bottom: 10,
                            left: 280,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.star, color: Colors.orange),
                                const SizedBox(width: 5),
                                Text(
                                  movie.voteAverage != null
                                      ? movie.voteAverage!.toStringAsFixed(1)
                                      : 'N/A',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                        ],
                      ),
                    );
                  }

                  if (state is MovieDetailsFalure) {
                    return Center(child: Text(state.falureMessage));
                  }

                  return const SizedBox.shrink();
                },
              ),
              SizedBox(height: 80),
              BlocBuilder<MovieDetailsCubit, MovieDetailsState>(
                builder: (context, state) {
                  if (state is MovieDetailsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is MovieDetailsSuccess) {
                    final movie = state.moviesdetails;
                    return Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomMovieInfo(
                            icon: Icons.date_range,
                            text:
                                movie.releaseDate != null &&
                                    movie.releaseDate!.isNotEmpty
                                ? movie.releaseDate!.split('-')[0]
                                : 'N/A',
                            iconColor: AppColors.hintcolor,
                            textColor: AppColors.hintcolor,
                            iconSize: 18,
                            fontSize: 14,
                          ),
                          SizedBox(width: 10),
                          SizedBox(
                            height: 20,
                            child: VerticalDivider(
                              color: Colors.grey,
                              thickness: 1,
                              width: 10,
                            ),
                          ),
                          SizedBox(width: 10),
                          CustomMovieInfo(
                            text: movie.runtime != null
                                ? "${movie.runtime} Minutes"
                                : 'N/A',
                            icon: Icons.access_time,
                            iconColor: AppColors.hintcolor,
                            textColor: AppColors.hintcolor,
                            iconSize: 18,
                            fontSize: 14,
                          ),
                          SizedBox(width: 10),
                          SizedBox(
                            height: 20,
                            child: VerticalDivider(
                              color: Colors.grey,
                              thickness: 1,
                              width: 10,
                            ),
                          ),
                          SizedBox(width: 10),
                          CustomMovieInfo(
                            text:
                                movie.genres != null && movie.genres!.isNotEmpty
                                ? movie.genres!.first.name ?? 'No Genre'
                                : 'No Genre',

                            icon: Icons.confirmation_number_outlined,
                            iconColor: AppColors.hintcolor,
                            textColor: AppColors.hintcolor,
                            iconSize: 18,
                            fontSize: 14,
                          ),
                        ],
                      ),
                    );
                  }
                  if (state is MovieDetailsFalure) {
                    return Center(child: Text(state.falureMessage));
                  }
                  return const SizedBox.shrink();
                },
              ),
              SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: TabBar(
                  tabs: [
                    Tab(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'About_Movie'.tr(),
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
                          'Reviews'.tr(),
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
                          'Cast'.tr(),
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                  dividerHeight: 0,
                  indicatorColor: AppColors.hintcolor,
                  indicatorSize: TabBarIndicatorSize.label,
                ),
              ),

              Expanded(
                child: TabBarView(
                  children: [
                    BlocBuilder<MovieDetailsCubit, MovieDetailsState>(
                      builder: (context, state) {
                        if (state is MovieDetailsLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (state is MovieDetailsSuccess) {
                          final movies = state.moviesdetails;

                          return Container(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                              top: 20,
                              bottom: 20,
                            ),
                            child: SingleChildScrollView(
                              child: Text(
                                movies.overview ?? 'No Overview Available',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textColor,
                                ),
                              ),
                            ),
                          );
                        }
                        if (state is MovieDetailsFalure) {
                          return Center(
                            child: Text(
                              state.falureMessage,
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    BlocBuilder<ReviewCubit, ReviewState>(
                      builder: (context, state) {
                        if (state is ReviewLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is ReviewSuccess) {
                          final reviews = state.reviews;
                          if (reviews.isEmpty) {
                            return const Center(
                              child: Text(
                                'No reviews available for this movie.',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            );
                          }
                          return ReviewsListView(reviews: reviews);
                        }
                        if (state is ReviewFailure) {
                          return Center(child: Text(state.error));
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    BlocBuilder<CastCubit, CastState>(
                      builder: (context, state) {
                        if (state is CastLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is CastSuccess) {
                          final castList =
                              state.cast; // البيانات اللي راجعة من Cubit

                          if (castList.isEmpty) {
                            return const Center(
                              child: Text(
                                'No cast information available.',
                                style: TextStyle(color: Colors.white70),
                              ),
                            );
                          }

                          return GridView.builder(
                            padding: const EdgeInsets.all(12),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: 1.3,
                                ),
                            itemCount: castList.length,
                            itemBuilder: (context, index) {
                              final actor = castList[index];

                              return CustomCastInfo(
                                imageUrl: actor.profilePath ?? '',
                                name: actor.name ?? 'Unknown',
                              );
                            },
                          );
                        }
                        if (state is CastFailure) {
                          return Center(child: Text(state.error));
                        }
                        return Container();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}