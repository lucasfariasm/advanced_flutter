import 'package:advanced_flutter/domain/entities/next_event_player.dart';

import 'package:flutter_test/flutter_test.dart';

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
    expect(initialsOf('Lucas'), 'LU');
    expect(initialsOf('L'), 'L');
  });

  test('should return "-" when name is empty', () {
    expect(initialsOf(''), '-');
  });

  test('should convert to uppercase', () {
    expect(initialsOf('lucas farias'), 'LF');
    expect(initialsOf('lucas'), 'LU');
    expect(initialsOf('l'), 'L');
  });

  test('should ignore extra whitespaces', () {
    expect(initialsOf('Lucas Farias '), 'LF');
    expect(initialsOf(' Lucas Farias'), 'LF');
    expect(initialsOf('Lucas  Farias'), 'LF');
    expect(initialsOf(' Lucas  Farias '), 'LF');
    expect(initialsOf(' Lucas '), 'LU');
    expect(initialsOf(' L '), 'L');
    expect(initialsOf(' '), '-');
    expect(initialsOf('  '), '-');
  });
}
