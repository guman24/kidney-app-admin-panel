import 'package:flutter/material.dart';
import 'package:kidney_admin/core/constants/media_assets.dart';

class PostDetailUserProfileAvatar extends StatelessWidget {
  const PostDetailUserProfileAvatar({super.key, required this.username});

  final String username;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Row(
        spacing: 12.0,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox.square(
            dimension: 50,
            child: DecoratedBox(
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: ClipOval(
                child: Image.asset(
                  ImageAssets.oliverCute,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(username, style: Theme.of(context).textTheme.titleMedium),
              Text(
                "Nutrition Expert",
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
