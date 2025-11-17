import 'package:flutter/material.dart';

class CustomMovieImage extends StatelessWidget {
  final String imageUrl;

  const CustomMovieImage({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        "https://image.tmdb.org/t/p/w500/$imageUrl",
        fit: BoxFit.fill,
        errorBuilder: (context, error, stackTrace) =>
            const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
      ),
    );
  }
}
