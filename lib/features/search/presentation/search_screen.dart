import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:movie_app/features/home/presentation/component/custom_textformfield_search.dart';
import 'package:movie_app/features/search/component/search_card.dart';
import 'package:movie_app/features/search/controllers/cubit/search_cubit.dart';
import 'package:movie_app/core/theme/colors.dart';

class SearchScreen extends StatefulWidget {
  final String query;

  const SearchScreen({super.key, required this.query});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController controller;
  @override
  initState() {
    super.initState();
    controller = TextEditingController(text: widget.query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.numberscolor,
      appBar: AppBar(
        backgroundColor: AppColors.numberscolor,
        title: Text(
          "Search Screen",
          style: TextStyle(color: AppColors.textColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Column(
          children: [
            CustomTextFormFieldSearch(
              controller: controller,
              onFieldSubmitted: (value) {
                context.read<SearchCubit>().search(controller.text.trim());
              },
            ),
            SizedBox(height: 18),
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  if (state is SearchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SearchSuccess) {
                    final results = state.searchResults;

                    if (results.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Lottie.asset(
                              'assets/lotties/EmptyBox.json',
                              height: 200,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No Result'.tr(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14.0,
                        vertical: 12,
                      ),
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final movie = results[index];
                        return MovieCard(movie: movie);
                      },
                    );
                  } else if (state is SearchFailure) {
                    return Center(
                      child: Text(
                        'Error: ${state.message}',
                        style: TextStyle(color: AppColors.textColor),
                      ),
                    );
                  } else {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Lottie.asset(
                            'assets/lotties/EmptyBox.json',
                            height: 200,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "No Search",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
