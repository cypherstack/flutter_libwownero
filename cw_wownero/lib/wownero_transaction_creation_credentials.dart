import 'package:wow_cw_core/monero_transaction_priority.dart';
import 'package:wow_cw_core/output_info.dart';

class WowneroTransactionCreationCredentials {
  WowneroTransactionCreationCredentials({this.outputs, this.priority});

  final List<OutputInfo>? outputs;
  final WowneroTransactionPriority? priority;
}
