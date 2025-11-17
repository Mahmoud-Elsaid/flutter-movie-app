import 'package:flutter/material.dart';

class CustomCastInfo extends StatelessWidget {
  final String imageUrl;
  final String name;

  const CustomCastInfo({super.key, required this.imageUrl, required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: imageUrl.isNotEmpty
              ? NetworkImage("https://image.tmdb.org/t/p/w500/$imageUrl")
              : const AssetImage('assets/images/avatar.png') as ImageProvider,
          onBackgroundImageError: (_, __) {}, 
        ),
        const SizedBox(height: 8),
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
