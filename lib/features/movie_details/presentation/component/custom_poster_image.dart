import 'package:flutter/material.dart';

class CustomMoviePosterDetails extends StatelessWidget {
  final String imageUrl;

  const CustomMoviePosterDetails({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16),bottomRight: Radius.circular(16)),
      child: Image.network(
        "https://image.tmdb.org/t/p/w500/$imageUrl",
        fit: BoxFit.fill,
        errorBuilder: (context, error, stackTrace) =>
            const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
      ),
    );
  }
}
