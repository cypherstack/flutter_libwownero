import 'dart:convert';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as ioc;
import 'package:wow_cw_core/keyable.dart';
import 'package:wow_cw_core/wallet_type.dart';

part 'node.g.dart';

Uri? createUriFromElectrumAddress(String? address) =>
    Uri.tryParse('tcp://$address');

@HiveType(typeId: WowneroNode.typeId)
class WowneroNode /*extends HiveObject*/ with Keyable {
  WowneroNode(
      {required String uri,
      required WalletType type,
      this.login,
      this.password,
      this.useSSL}) {
    uriRaw = uri;
    this.type = type;
  }

  WowneroNode.fromMap(Map map)
      : uriRaw = map['uri'] as String? ?? '',
        login = map['login'] as String?,
        password = map['password'] as String?,
        typeRaw = map['typeRaw'] as int?,
        useSSL = map['useSSL'] as bool?;

  static const typeId = 1;
  static const boxName = 'WowneroNodes';

  @HiveField(0)
  String? uriRaw;

  @HiveField(1)
  String? login;

  @HiveField(2)
  String? password;

  @HiveField(3)
  int? typeRaw;

  @HiveField(4)
  bool? useSSL;

  bool get isSSL => useSSL ?? false;

  Uri? get uri {
    switch (type) {
      case WalletType.monero:
        return Uri.http(uriRaw!, '');
      case WalletType.bitcoin:
        return createUriFromElectrumAddress(uriRaw);
      case WalletType.litecoin:
        return createUriFromElectrumAddress(uriRaw);
      case WalletType.haven:
        return Uri.http(uriRaw!, '');
      case WalletType.wownero:
        return Uri.http(uriRaw!, '');
      default:
        return null;
    }
  }

  @override
  dynamic get keyIndex {
    _keyIndex ??= 0;
    return _keyIndex;
  }

  WalletType? get type => deserializeFromInt(typeRaw);

  set type(WalletType? type) => typeRaw = serializeToInt(type);

  dynamic _keyIndex;

  Future<bool> requestNode() async {
    try {
      switch (type) {
        case WalletType.monero:
        case WalletType.wownero:
          return requestMoneroNode();
        case WalletType.bitcoin:
          return requestElectrumServer();
        case WalletType.litecoin:
          return requestElectrumServer();
        default:
          return false;
      }
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

  Future<bool> requestElectrumServer() async {
    try {
      await SecureSocket.connect(uri!.host, uri!.port,
          timeout: Duration(seconds: 5), onBadCertificate: (_) => true);
      return true;
    } catch (_) {
      return false;
    }
  }
}
