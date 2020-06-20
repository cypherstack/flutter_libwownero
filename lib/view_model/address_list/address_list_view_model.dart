import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:cake_wallet/bitcoin/bitcoin_wallet.dart';
import 'package:cake_wallet/monero/monero_wallet.dart';
import 'package:cake_wallet/core/wallet_base.dart';
import 'package:cake_wallet/utils/list_item.dart';
import 'package:cake_wallet/view_model/address_list/account_list_header.dart';
import 'package:cake_wallet/view_model/address_list/address_list_header.dart';
import 'package:cake_wallet/view_model/address_list/address_list_item.dart';

part 'address_list_view_model.g.dart';

class AddressListViewModel = AddressListViewModelBase
    with _$AddressListViewModel;

abstract class PaymentURI {
  PaymentURI({this.amount, this.address});

  final String amount;
  final String address;
}

class MoneroURI extends PaymentURI {
  MoneroURI({String amount, String address})
      : super(amount: amount, address: address);

  @override
  String toString() {
    var base = 'monero:' + address;

    if (amount?.isNotEmpty ?? false) {
      base += '?tx_amount=$amount';
    }

    return base;
  }
}

class BitcoinURI extends PaymentURI {
  BitcoinURI({String amount, String address})
      : super(amount: amount, address: address);

  @override
  String toString() {
    var base = 'bitcoin:' + address;

    if (amount?.isNotEmpty ?? false) {
      base += '?amount=$amount';
    }

    return base;
  }
}

abstract class AddressListViewModelBase with Store {
  AddressListViewModelBase({@required WalletBase wallet}) {
    hasAccounts = _wallet is MoneroWallet;
    _wallet = wallet;
    _init();
  }

  @observable
  String amount;

  @computed
  AddressListItem get address => AddressListItem(address: _wallet.address);

  @computed
  PaymentURI get uri {
    if (_wallet is MoneroWallet) {
      return MoneroURI(amount: amount, address: address.address);
    }

    if (_wallet is BitcoinWallet) {
      return BitcoinURI(amount: amount, address: address.address);
    }

    return null;
  }

  @computed
  ObservableList<ListItem> get items =>
      ObservableList<ListItem>()..addAll(_baseItems)..addAll(addressList);

  @computed
  ObservableList<ListItem> get addressList {
    final wallet = _wallet;
    final addressList = ObservableList<ListItem>();

    if (wallet is MoneroWallet) {
      addressList.addAll(wallet.subaddressList.subaddresses.map((subaddress) =>
          AddressListItem(
              id: subaddress.id,
              name: subaddress.label,
              address: subaddress.address)));
    }

    if (wallet is BitcoinWallet) {
      final bitcoinAddresses = wallet.addresses.map(
          (addr) => AddressListItem(name: addr.label, address: addr.address));
      addressList.addAll(bitcoinAddresses);
    }

    return addressList;
  }

  set address(AddressListItem address) => _wallet.address = address.address;

  bool hasAccounts;

  WalletBase _wallet;

  List<ListItem> _baseItems;

  @computed
  String get accountLabel {
    final wallet = _wallet;

    if (wallet is MoneroWallet) {
      return wallet.account.label;
    }

    return null;
  }

  void _init() {
    _baseItems = [];

    if (_wallet is MoneroWallet) {
      _baseItems.add(AccountListHeader());
    }

    _baseItems.add(AddressListHeader());
  }
}