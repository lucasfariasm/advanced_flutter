@Timeout(Duration(seconds: 1))
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/subjects.dart';

import '../../helpers/fakes.dart';

final class NextEventRxPresenter {
  final Future<void> Function({required String groupId}) nextEventLoader;
  final nextEventSubject = BehaviorSubject();
  final isBusySubject = BehaviorSubject<bool>();

  NextEventRxPresenter({
    required this.nextEventLoader,
  });

  Stream get nextEventStream => nextEventSubject.stream;
  Stream<bool> get isBusyStream => isBusySubject.stream;

  Future<void> loadNextEvent({
    required String groupId,
    bool isReload = false,
  }) async {
    try {
      isBusySubject.add(true);
      await nextEventLoader(groupId: groupId);
    } catch (error) {
      nextEventSubject.addError(error);
      isBusySubject.add(false);
    }
  }
}

final class NextEventLoaderSpy {
  int callsCount = 0;
  String? groupId;
  Error? error;

  Future<void> call({required String groupId}) async {
    this.groupId = groupId;
    callsCount++;
    if (error != null) throw error!;
  }
}

void main() {
  late NextEventLoaderSpy nextEventLoader;
  late String groupId;
  late NextEventRxPresenter sut;

  setUp(() {
    nextEventLoader = NextEventLoaderSpy();
    groupId = anyString();
    sut = NextEventRxPresenter(nextEventLoader: nextEventLoader.call);
  });

  test('should get event data', () async {
    await sut.loadNextEvent(groupId: groupId);
    expect(nextEventLoader.callsCount, 1);
    expect(nextEventLoader.groupId, groupId);
  });

  test('should emit correct events on reload with error', () async {
    nextEventLoader.error = Error();
    expectLater(sut.nextEventStream, emitsError(nextEventLoader.error));
    expectLater(sut.isBusyStream, emitsInOrder([true, false]));
    await sut.loadNextEvent(groupId: groupId, isReload: true);
  });
}
