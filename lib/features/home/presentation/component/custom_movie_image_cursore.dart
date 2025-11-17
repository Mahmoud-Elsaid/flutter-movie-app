import 'package:flutter/material.dart';
import 'package:movie_app/core/theme/colors.dart';

class CustomCarouselMovieImage extends StatelessWidget {
  final String imageUrl;
  final int index;
  final int movieId;
  final VoidCallback? onTap;

  const CustomCarouselMovieImage({
    super.key,
    required this.imageUrl,
    required this.index,
    required this.movieId,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                "https://image.tmdb.org/t/p/w500/$imageUrl",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
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
                        ..color = Colors.blueGrey.withOpacity(0.8),
                    ),
                  ),
                  Text(
                    "${index + 1}",
                    style: TextStyle(
                      fontSize: 55,
                      fontWeight: FontWeight.bold,
                      color: AppColors.numberscolor.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}






















































/* import 'package:flutter/material.dart';
import 'package:movie_app/core/colors.dart';

class CustomCarouselMovieImage extends StatelessWidget {
  final String imageUrl;
  final int index;

  const CustomCarouselMovieImage({
    super.key,
    required this.imageUrl,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              "https://image.tmdb.org/t/p/w500/$imageUrl",
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
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
                      ..color = Colors.blueGrey.withOpacity(0.8),
                  ),
                ),
                Text(
                  "${index + 1}",
                  style: TextStyle(
                    fontSize: 55,
                    fontWeight: FontWeight.bold,
                    color: AppColors.numberscolor.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} */
