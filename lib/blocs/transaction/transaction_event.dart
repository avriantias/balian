part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object> get props => [];
}

class FetchTransactionsEvent extends TransactionEvent {
  final String token;

  const FetchTransactionsEvent({required this.token});

  @override
  List<Object> get props => [token];
}

class AddTransactionEvent extends TransactionEvent {
  final TransactionModel transaction;

  const AddTransactionEvent({required this.transaction});

  @override
  List<Object> get props => [transaction];
}

class CancelTransactionEvent extends TransactionEvent {
  final String transactionId;
  final String token;

  const CancelTransactionEvent(
      {required this.transactionId, required this.token});

  @override
  List<Object> get props => [transactionId];
}
