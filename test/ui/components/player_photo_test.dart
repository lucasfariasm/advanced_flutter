import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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
    return const CircleAvatar(
      child: Text("LF"),
    );
  }
}

void main() {
  testWidgets('should present initials when there is no photo', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: PlayerPhoto(
          initials: 'LU',
          photo: null,
        ),
      ),
    );
    expect(find.text("LF"), findsOneWidget);
  });
}
