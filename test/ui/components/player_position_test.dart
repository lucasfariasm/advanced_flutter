import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class PlayerPosition extends StatelessWidget {
  final String? position;

  const PlayerPosition({
    super.key,
    this.position,
  });

  String buildPositionLabel() => switch (position) {
        'goalkeeper' => 'Goleiro',
        _ => 'Gandula',
      };

  @override
  Widget build(BuildContext context) {
    return Text(buildPositionLabel());
  }
}

void main() {
  testWidgets('should handle goalkeeper position', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: PlayerPosition(
        position: 'goalkeeper',
      ),
    ));
    expect(find.text("Goleiro"), findsOneWidget);
  });

  testWidgets('should handle positionless', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: PlayerPosition(
        position: null,
      ),
    ));
    expect(find.text("Gandula"), findsOneWidget);
  });
}
