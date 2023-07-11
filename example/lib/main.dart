import 'dart:core';
import 'dart:core' as core;
import 'dart:io';
import 'dart:math';

import 'package:cw_wownero/api/wallet.dart';
import 'package:cw_wownero/pending_wownero_transaction.dart';
import 'package:cw_wownero/wownero_wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_libwownero/core/key_service.dart';
import 'package:flutter_libwownero/core/wallet_creation_service.dart';
import 'package:flutter_libwownero/view_model/send/output.dart';
import 'package:flutter_libwownero/wownero/wownero.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wow_cw_core/monero_amount_format.dart';
import 'package:wow_cw_core/node.dart';
import 'package:wow_cw_core/pending_transaction.dart';
import 'package:wow_cw_core/wallet_base.dart';
import 'package:wow_cw_core/wallet_credentials.dart';
import 'package:wow_cw_core/wallet_info.dart';
import 'package:wow_cw_core/wallet_service.dart';
import 'package:cw_wownero/wownero_wallet_service.dart';

FlutterSecureStorage? storage;
WowneroWalletService? walletService;
SharedPreferences? prefs;
KeyService? keysStorage;
WowneroWalletBase? walletBase;
late WalletCreationService _walletCreationService;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory appDir = (await getApplicationDocumentsDirectory());
  if (Platform.isIOS) {
    appDir = (await getLibraryDirectory());
  }
  await Hive.close();
  Hive.init(appDir.path);

  // if (!Hive.isAdapterRegistered(WalletInfo.typeId)) {
  Hive.registerAdapter(WalletInfoAdapter());
  // }

  wownero.onStartup();
  final _walletInfoSource = await Hive.openBox<WowneroWalletInfo>(WowneroWalletInfo.boxName);
  walletService = wownero.createWowneroWalletService(_walletInfoSource);
  storage = FlutterSecureStorage();
  prefs = await SharedPreferences.getInstance();
  keysStorage = KeyService(storage!);
  WowneroWalletInfo walletInfo;
  late WowneroWalletCredentials credentials;
  try {
    // if (name?.isEmpty ?? true) {
    // name = await generateName();
    // }
    String name = "namee${Random().nextInt(10000000)}";
    final dirPath = await pathForWalletDir(name: name);
    final path = await pathForWallet(name: name);
    credentials =
        // //     creating a new wallet
        // wownero.createWowneroNewWalletCredentials(
        //     name: name, language: "English");
        // restoring a previous wallet
        wownero.createWowneroRestoreWalletFromSeedCredentials(
      name: name,
      height: 2580000,
      mnemonic: "water water water water water "
          "water water water water water "
          "water water water water water "
          "water water water water water "
          "water water water water water",
    );
    walletInfo = WowneroWalletInfo.external(
        id: WalletBase.idFor(name),
        name: name,
        isRecovery: false,
        restoreHeight: credentials.height ?? 0,
        date: DateTime.now(),
        path: path,
        address: "",
        dirPath: dirPath);
    credentials.walletInfo = walletInfo;

    _walletCreationService = WalletCreationService(
      secureStorage: storage,
      sharedPreferences: prefs,
      walletService: walletService,
      keyService: keysStorage,
    );
    // To restore from a seed
    final wallet = await
        // _walletCreationService.create(credentials);
        _walletCreationService.restoreFromSeed(credentials);
    // to create a new wallet
    // final wallet = await process(credentials);
    walletInfo.address = wallet.walletAddresses.address;
    print(walletInfo.address);
    await _walletInfoSource.add(walletInfo);
    walletBase?.close();
    walletBase = wallet as WowneroWalletBase;
    print("${walletBase?.seed}");
  } catch (e, s) {
    print(e);
    print(s);
  }
  // print(walletBase);
  // loggerPrint(walletBase.toString());
  // loggerPrint("name: ${walletBase!.name}  seed: ${walletBase!.seed} id: "
  //     "${walletBase!.id} walletinfo: ${toStringForinfo(walletBase!.walletInfo)} type: ${walletBase!.type} balance: "
  //     "${walletBase!.balance.entries.first.value.available} currency: ${walletBase!.currency}");
  await walletBase?.connectToNode(
      node: Node(uri: "wownero.stackwallet.com:34568"));
  walletBase!.rescan(height: credentials.height);
  walletBase!.getNodeHeight();
  runApp(MyApp());
}

String toStringForinfo(WowneroWalletInfo info) {
  return "id: ${info.id}  name: ${info.name} recovery: ${info.isRecovery}"
      " restoreheight: ${info.restoreHeight} timestamp: ${info.timestamp} dirPath: ${info.dirPath} "
      "path: ${info.path} address: ${info.address} addresses: ${info.addresses}";
}

Future<String> pathForWalletDir({required String name}) async {
  Directory root = (await getApplicationDocumentsDirectory());
  if (Platform.isIOS) {
    root = (await getLibraryDirectory());
  }
  final prefix = "wownero";
  final walletsDir = Directory('${root.path}/wallets');
  final walletDire = Directory('${walletsDir.path}/$prefix/$name');

  if (!walletDire.existsSync()) {
    walletDire.createSync(recursive: true);
  }

  return walletDire.path;
}

Future<String> pathForWallet({required String name}) async =>
    await pathForWalletDir(name: name).then((path) => path + '/$name');

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String? platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      // platformVersion = await FlutterLibwownero.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(getSyncingHeight());
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Wownero Plugin example app'),
        ),
        body: Center(
          child: ListView(
            children: [
              Text(
                  "Transactions:${walletBase!.transactionHistory!.transactions}"),
              TextButton(
                  onPressed: () async {
                    String addr = walletBase!.getTransactionAddress(
                        wownero.getCurrentAccount(walletBase!).id!, 0);
                    loggerPrint("addr: $addr");
                    for (var bal in walletBase!.balance!.entries) {
                      loggerPrint(
                          "key: ${bal.key}, amount ${moneroAmountToString(amount: bal.value.available)}");
                    }
                  },
                  child: Text("amount")),
              TextButton(
                onPressed: () async {
                  Output output = Output(walletBase!); //
                  output.address =
                      "Wo5EdU75i8w9tWaUse8CVwUACK9K4uEjG86GQ3zp4RZe824ErKnFNqQYF6wPfg3Tq2LXnL2cAdVBnbcFD9vxbgvR1wGPCd3Dx";
                  output.setCryptoAmount("0.00001011");
                  List<Output> outputs = [output];
                  Object tmp =
                      wownero.createWowneroTransactionCreationCredentials(
                          outputs: outputs,
                          priority: wownero.getDefaultTransactionPriority());
                  loggerPrint(tmp);
                  Future<PendingTransaction> awaitPendingTransaction =
                      walletBase!.createTransaction(tmp);
                  loggerPrint(output);
                  PendingWowneroTransaction pendingWowneroTransaction =
                      await awaitPendingTransaction
                          as PendingWowneroTransaction;
                  loggerPrint(pendingWowneroTransaction);
                  loggerPrint(pendingWowneroTransaction.id);
                  loggerPrint(pendingWowneroTransaction.amountFormatted);
                  loggerPrint(pendingWowneroTransaction.feeFormatted);
                  loggerPrint(pendingWowneroTransaction
                      .pendingTransactionDescription.amount);
                  loggerPrint(pendingWowneroTransaction
                      .pendingTransactionDescription.hash);
                  loggerPrint(pendingWowneroTransaction
                      .pendingTransactionDescription.fee);
                  loggerPrint(pendingWowneroTransaction
                      .pendingTransactionDescription.pointerAddress);
                  try {
                    await pendingWowneroTransaction.commit();
                    loggerPrint(
                        "transaction ${pendingWowneroTransaction.id} has been sent");
                  } catch (e, s) {
                    loggerPrint("error");
                    loggerPrint(e);
                    loggerPrint(s);
                  }
                },
                child: Text("send Transaction"),
              ),
              // Text(
              //     "bob ${wowneroAmountToString(amount: walletBase.transactionHistory.transactions.entries.first.value.amount)}"),
              FutureBuilder(
                future: walletBase!
                    .getNodeHeight(), // a previously-obtained Future<String> or null
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  List<Widget> children;
                  if (snapshot.hasData) {
                    children = <Widget>[
                      const Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                        size: 60,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text('Result: ${snapshot.data}'),
                      )
                    ];
                  } else if (snapshot.hasError) {
                    children = <Widget>[
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text('Error: ${snapshot.error}'),
                      )
                    ];
                  } else {
                    children = const <Widget>[
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text('Awaiting result...'),
                      )
                    ];
                  }
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: children,
                    ),
                  );
                },
              ),
            ],
          ),
          // Text(
          //     'Running on: $_platformVersion\n ${walletBase.getNodeHeight()}'),
        ),
      ),
    );
  }
}

void loggerPrint(core.Object? object) async {
  final utcTime = core.DateTime.now().toUtc().toString() + ": ";
  core.int defaultPrintLength = 1020 - utcTime.length;
  if (object == null || object.toString().length <= defaultPrintLength) {
    core.print("$utcTime$object");
  } else {
    core.String log = object.toString();
    core.int start = 0;
    core.int endIndex = defaultPrintLength;
    core.int logLength = log.length;
    core.int tmpLogLength = log.length;
    while (endIndex < logLength) {
      core.print(utcTime + log.substring(start, endIndex));
      endIndex += defaultPrintLength;
      start += defaultPrintLength;
      tmpLogLength -= defaultPrintLength;
    }
    if (tmpLogLength > 0) {
      core.print(utcTime + log.substring(start, logLength));
    }
  }
}
