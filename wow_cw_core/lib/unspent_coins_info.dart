class UnspentCoinsInfo {
  UnspentCoinsInfo(
      {this.walletId, this.hash, this.isFrozen, this.isSending, this.note});

  String? walletId;

  String? hash;

  bool? isFrozen;

  bool? isSending;

  String? note;
}
