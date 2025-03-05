import 'package:flutter/material.dart';

class PlayerPosition extends StatelessWidget {
  final String? position;

  const PlayerPosition({
    super.key,
    this.position,
  });

  String buildPositionLabel() => switch (position) {
        'goalkeeper' => 'Goleiro',
        'defender' => 'Zagueiro',
        'midfielder' => 'Meia',
        'forward' => 'Atacante',
        _ => 'Gandula',
      };

  @override
  Widget build(BuildContext context) {
    return Text(buildPositionLabel());
  }
}
