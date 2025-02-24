import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

class NextEventLoader {
// propertie injection
//   LoadNextEventRepository? repo;
  final LoadNextEventRepository repo;

  NextEventLoader({required this.repo});

  Future<void> call({required String groupId}) async {
    await repo.loadNextEvent(groupId: groupId);
  }
}

abstract class LoadNextEventRepository {
  Future<void> loadNextEvent({required String groupId});
}

class LoadNextEventMockRepository implements LoadNextEventRepository {
  String? groupId;
  var callsCount = 0;

  @override
  Future<void> loadNextEvent({required String groupId}) async {
    this.groupId = groupId;
    callsCount++;
  }
}

void main() {
  test('should load event data from a repository', () async {
    final groupId = Random().nextInt(50000).toString();
    final repo = LoadNextEventMockRepository();
    final sut = NextEventLoader(repo: repo);
    // sut.repo = repo;
    await sut(groupId: groupId);
    expect(repo.groupId, groupId);
    expect(repo.callsCount, 1);
  });
}
