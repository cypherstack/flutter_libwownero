import 'package:flutter/material.dart';
import 'package:flutter_libwownero/entities/parsed_address.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:wow_cw_core/wallet_base.dart';

import '../../wownero/wownero.dart';

part 'output.g.dart';

const String cryptoNumberPattern = '0.0';

class Output = OutputBase with _$Output;

abstract class OutputBase with Store {
  OutputBase(
    this._wallet,
    // this._settingsStore, this._fiatConversationStore,
    // this.cryptoCurrencyHandler
  ) : _cryptoNumberFormat = NumberFormat(cryptoNumberPattern) {
    reset();
    _setCryptoNumMaximumFractionDigits();
    key = UniqueKey();
  }

  Key? key;

  @observable
  String? fiatAmount;

  @observable
  String? cryptoAmount;

  @observable
  String? address;

  @observable
  String? note;

  @observable
  bool? sendAll;

  @observable
  ParsedAddress? parsedAddress;

  @observable
  String? extractedAddress;

  @computed
  bool get isParsedAddress =>
      parsedAddress!.parseFrom != ParseFrom.notParsed &&
      parsedAddress!.name.isNotEmpty;

  @computed
  int get formattedCryptoAmount {
    int amount = 0;

    try {
      if (cryptoAmount?.isNotEmpty ?? false) {
        final _cryptoAmount = cryptoAmount!.replaceAll(',', '.');
        final int _amount =
            wownero.formatterWowneroParseAmount(amount: _cryptoAmount);

        if (_amount > 0) {
          amount = _amount;
        }
      }
    } catch (e) {
      amount = 0;
    }

    return amount;
  }

  @computed
  double get estimatedFee {
    try {
      //TODO: should not be default fee, should be user chosen
      final fee = _wallet.calculateEstimatedFee(
          wownero.getDefaultTransactionPriority(), formattedCryptoAmount);

      return wownero.formatterWowneroAmountToDouble(amount: fee);
    } catch (e) {
      print(e.toString());
    }

    return 0;
  }
  //
  // @computed
  // String get estimatedFeeFiatAmount {
  //   try {
  //     final fiat = calculateFiatAmountRaw(
  //         price: _fiatConversationStore.prices[cryptoCurrencyHandler()],
  //         cryptoAmount: estimatedFee);
  //     return fiat;
  //   } catch (_) {
  //     return '0.00';
  //   }
  // }

  // final CryptoCurrency Function() cryptoCurrencyHandler;
  final WalletBase _wallet;
  // final SettingsStore _settingsStore;
  // final FiatConversionStore _fiatConversationStore;
  final NumberFormat _cryptoNumberFormat;

  @action
  void setSendAll() => sendAll = true;

  @action
  void reset() {
    sendAll = false;
    cryptoAmount = '';
    fiatAmount = '';
    address = '';
    note = '';
    resetParsedAddress();
  }

  void resetParsedAddress() {
    extractedAddress = '';
    parsedAddress = ParsedAddress(addresses: []);
  }

  @action
  void setCryptoAmount(String amount) {
    // if (amount.toUpperCase() != S.current.all) {
    //   sendAll = false;
    // }

    cryptoAmount = amount;
    // _updateFiatAmount();
  }

  // @action
  // void setFiatAmount(String amount) {
  //   fiatAmount = amount;
  //   _updateCryptoAmount();
  // }

  // @action
  // void _updateFiatAmount() {
  //   try {
  //     final fiat = calculateFiatAmount(
  //         price: _fiatConversationStore.prices[cryptoCurrencyHandler()],
  //         cryptoAmount: cryptoAmount.replaceAll(',', '.'));
  //     if (fiatAmount != fiat) {
  //       fiatAmount = fiat;
  //     }
  //   } catch (_) {
  //     fiatAmount = '';
  //   }
  // }
  //
  // @action
  // void _updateCryptoAmount() {
  //   try {
  //     final crypto = double.parse(fiatAmount.replaceAll(',', '.')) /
  //         _fiatConversationStore.prices[cryptoCurrencyHandler()];
  //     final cryptoAmountTmp = _cryptoNumberFormat.format(crypto);
  //
  //     if (cryptoAmount != cryptoAmountTmp) {
  //       cryptoAmount = cryptoAmountTmp;
  //     }
  //   } catch (e) {
  //     cryptoAmount = '';
  //   }
  // }

  void _setCryptoNumMaximumFractionDigits() {
    _cryptoNumberFormat.maximumFractionDigits =
        11; // TODO: (fix) this constant is declared in multiple places
  }

  // Future<void> fetchParsedAddress(BuildContext context) async {
  //   final domain = address;
  //   final ticker = cryptoCurrencyHandler().title.toLowerCase();
  //   parsedAddress = await getIt.get<AddressResolver>().resolve(domain, ticker);
  //   extractedAddress = await extractAddressFromParsed(context, parsedAddress);
  //   note = parsedAddress.description;
  // }
}
