import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

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
      foregroundImage: photo != null ? NetworkImage(photo!) : null,
      child: photo == null ? Text(initials) : null,
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
    expect(find.text("LU"), findsOneWidget);
  });

  testWidgets('should hide initials when there is photo', (tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PlayerPhoto(
            initials: 'LU',
            photo: "http://any-url.com",
          ),
        ),
      );
      expect(find.text("LU"), findsNothing);
    });
  });
}
