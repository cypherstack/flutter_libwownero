import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as ioc;

Uri? createUriFromElectrumAddress(String? address) =>
    Uri.tryParse('tcp://$address');

class Node {
  Node({
    required String uri,
    this.login,
    this.password,
    this.useSSL,
  }) {
    uriRaw = uri;
  }

  WowneroNode.fromMap(Map map)
      : uriRaw = map['uri'] as String? ?? '',
        login = map['login'] as String?,
        password = map['password'] as String?,
        useSSL = map['useSSL'] as bool?;

  String? uriRaw;

  String? login;

  String? password;

  bool? useSSL;

  bool get isSSL => useSSL ?? false;

  Uri? get uri => Uri.http(uriRaw!, '');

  Future<bool> requestNode() async {
    try {
      return requestMoneroNode();
    } catch (_) {
      return false;
    }
  }

  Future<bool> requestMoneroNode() async {
    final path = '/json_rpc';
    final rpcUri = isSSL
        ? Uri.https(uri!.authority, path)
        : Uri.http(uri!.authority, path);
    final realm = 'monero-rpc';
    final body = {'jsonrpc': '2.0', 'id': '0', 'method': 'get_info'};

    try {
      final authenticatingClient = HttpClient();

      authenticatingClient.addCredentials(
        rpcUri,
        realm,
        HttpClientDigestCredentials(login ?? '', password ?? ''),
      );

      final http.Client client = ioc.IOClient(authenticatingClient);

      final response = await client.post(
        rpcUri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      client.close();

      final resBody = json.decode(response.body) as Map<String, dynamic>;
      return !(resBody['result']['offline'] as bool);
    } catch (_) {
      return false;
    }
  }
}
