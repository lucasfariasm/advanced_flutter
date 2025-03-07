import 'package:awesome_flutter_extensions/awesome_flutter_extensions.dart';
import 'package:flutter/material.dart';

class PlayerPhoto extends StatelessWidget {
  final String initials;
  final String? photo;

  const PlayerPhoto({
    super.key,
    required this.initials,
    this.photo,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 25,
      foregroundImage: photo != null ? NetworkImage(photo!) : null,
      child: photo == null
          ? Text(
              initials,
              style: context.textStyles.labelLarge,
            )
          : null,
    );
  }
}
