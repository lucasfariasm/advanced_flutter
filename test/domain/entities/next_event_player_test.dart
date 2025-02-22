import 'package:flutter_test/flutter_test.dart';

class NextEventPlayer {
  final String id;
  final String name;
  final String initials;
  final String? photo;
  final String? position;
  final bool isConfirmed;
  final DateTime? confirmationDate;

  NextEventPlayer._({
    required this.id,
    required this.name,
    required this.initials,
    required this.isConfirmed,
    this.photo,
    this.position,
    this.confirmationDate,
  });

  factory NextEventPlayer({
    required String id,
    required String name,
    String? photo,
    String? position,
    required bool isConfirmed,
    DateTime? confirmationDate,
  }) =>
      NextEventPlayer._(
        id: id,
        name: name,
        photo: photo,
        position: position,
        initials: _getInitials(name),
        isConfirmed: isConfirmed,
        confirmationDate: confirmationDate,
      );

  static String _getInitials(String name) {
    final names = name.split(' ');
    final firstChar = names.first[0];
    final lastChar = names.last[names.length == 1 ? 1 : 0];
    return '$firstChar$lastChar';
  }
}

void main() {
  String initialsOf(String name) => NextEventPlayer(
        id: '',
        name: name,
        isConfirmed: true,
      ).initials;

  test('should return the first letter of the first and last name', () {
    expect(initialsOf('Lucas Farias'), 'LF');
    expect(initialsOf('Lucas Farias de Moura'), 'LM');
  });

  test('should return the first letters of the first name', () {
    expect(initialsOf('Lucas'), 'Lu');
  });
}
