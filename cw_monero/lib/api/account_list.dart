import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:cw_monero/api/signatures.dart';
import 'package:cw_monero/api/types.dart';
import 'package:cw_monero/api/monero_api.dart';
import 'package:cw_monero/api/structs/account_row.dart';
import 'package:flutter/foundation.dart';
import 'package:cw_monero/api/wallet.dart';
import 'package:ffi/ffi.dart' as pkgffi;

final accountSizeNative = moneroApi
    .lookup<NativeFunction<account_size>>('account_size')
    .asFunction<SubaddressSize>();

final accountRefreshNative = moneroApi
    .lookup<NativeFunction<account_refresh>>('account_refresh')
    .asFunction<AccountRefresh>();

final accountGetAllNative = moneroApi
    .lookup<NativeFunction<account_get_all>>('account_get_all')
    .asFunction<AccountGetAll>();

final accountAddNewNative = moneroApi
    .lookup<NativeFunction<account_add_new>>('account_add_row')
    .asFunction<AccountAddNew>();

final accountSetLabelNative = moneroApi
    .lookup<NativeFunction<account_set_label>>('account_set_label_row')
    .asFunction<AccountSetLabel>();

bool isUpdating = false;

void refreshAccounts() {
  try {
    isUpdating = true;
    accountRefreshNative();
    isUpdating = false;
  } catch (e) {
    isUpdating = false;
    rethrow;
  }
}

List<AccountRow> getAllAccount() {
  final size = accountSizeNative();
  final accountAddressesPointer = accountGetAllNative();
  final accountAddresses = accountAddressesPointer.asTypedList(size);

  return accountAddresses
      .map((addr) => Pointer<AccountRow>.fromAddress(addr).ref)
      .toList();
}

void addAccountSync({required String label}) {
  final labelPointer = label.toNativeUtf8();
  accountAddNewNative(labelPointer);
  pkgffi.calloc.free(labelPointer);
}

void setLabelForAccountSync({int? accountIndex, required String label}) {
  final labelPointer = label.toNativeUtf8();
  accountSetLabelNative(accountIndex, labelPointer);
  pkgffi.calloc.free(labelPointer);
}

void _addAccount(String? label) => addAccountSync(label: label!);

void _setLabelForAccount(Map<String, dynamic> args) {
  final label = args['label'] as String;
  final accountIndex = args['accountIndex'] as int?;

  setLabelForAccountSync(label: label, accountIndex: accountIndex);
}

Future<void> addAccount({String? label}) async {
  await compute(_addAccount, label);
  await store();
}

Future<void> setLabelForAccount({int? accountIndex, String? label}) async {
  await compute(
      _setLabelForAccount, {'accountIndex': accountIndex, 'label': label});
  await store();
}
