import 'package:advanced_flutter/domain/entities/next_event.dart';
import 'package:advanced_flutter/domain/entities/next_event_player.dart';
import 'package:advanced_flutter/domain/repositories/load_next_event_repo.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fakes.dart';

class LoadNextEventApiRepository implements LoadNextEventRepository {
  final HttpGetClient httpClient;
  final String url;

  LoadNextEventApiRepository({required this.httpClient, required this.url});

  @override
  Future<NextEvent> loadNextEvent({required String groupId}) async {
    final json = await httpClient
        .get<Map<String, dynamic>>(url: url, params: {"groupId": groupId});

    return NextEventMapper.toObject(json);
  }
}

class NextEventMapper {
  static NextEvent toObject(Map<String, dynamic> json) => NextEvent(
        groupName: json['groupName'],
        date: DateTime.parse(json['date']),
        players: NextEventPlayerMapper.toList(json['players']),
      );
}

class NextEventPlayerMapper {
  static List<NextEventPlayer> toList(List<Map<String, dynamic>> arr) =>
      arr.map(NextEventPlayerMapper.toObject).toList();

  static NextEventPlayer toObject(Map<String, dynamic> json) => NextEventPlayer(
        id: json['id'],
        name: json['name'],
        position: json['position'],
        photo: json['photo'],
        confirmationDate: DateTime.tryParse(json['confirmationDate'] ?? ''),
        isConfirmed: json['isConfirmed'],
      );
}

abstract class HttpGetClient {
  Future<T> get<T>({required String url, Map<String, String>? params});
}

class HttpGetClientSpy implements HttpGetClient {
  String? url;
  int callsCount = 0;
  Map<String, String>? params;
  dynamic response;
  Error? error;

  @override
  Future<T> get<T>({required String url, Map<String, String>? params}) async {
    this.url = url;
    this.params = params;
    callsCount++;
    if (error != null) throw error!;
    return response;
  }
}

void main() {
  late String groupId;
  late String url;
  late HttpGetClientSpy httpClient;
  late LoadNextEventApiRepository sut;

  setUp(() {
    groupId = anyString();
    url = anyString();
    httpClient = HttpGetClientSpy();
    httpClient.response = {
      "groupName": "any name",
      "date": "2025-02-26T10:30",
      "players": [
        {"id": "id 1", "name": "name 1", "isConfirmed": true},
        {
          "id": "id 2",
          "name": "name 2",
          "position": "position 2",
          "photo": "photo 2",
          "confirmationDate": "2025-02-25T11:00",
          "isConfirmed": false
        }
      ]
    };
    sut = LoadNextEventApiRepository(httpClient: httpClient, url: url);
  });

  test('should call HttpClient with correct input', () async {
    await sut.loadNextEvent(groupId: groupId);
    expect(httpClient.url, url);
    expect(httpClient.params, {"groupId": groupId});
    expect(httpClient.callsCount, 1);
  });

  test('should return NextEvent on success', () async {
    final event = await sut.loadNextEvent(groupId: groupId);
    expect(event.groupName, 'any name');
    expect(event.date, DateTime(2025, 2, 26, 10, 30));
    expect(event.players[0].id, 'id 1');
    expect(event.players[0].name, 'name 1');
    expect(event.players[0].isConfirmed, true);

    expect(event.players[1].id, 'id 2');
    expect(event.players[1].name, 'name 2');
    expect(event.players[1].position, 'position 2');
    expect(event.players[1].photo, 'photo 2');
    expect(event.players[1].confirmationDate, DateTime(2025, 2, 25, 11, 0));
    expect(event.players[1].isConfirmed, false);
  });

  test('should rethrow on error', () async {
    final error = Error();
    httpClient.error = error;
    final future = sut.loadNextEvent(groupId: groupId);
    expect(future, throwsA(error));
  });
}
