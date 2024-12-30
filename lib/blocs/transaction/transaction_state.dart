part of 'transaction_bloc.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<TransactionItemModel> transactions;

  const TransactionLoaded({
    required this.transactions,
  });

  @override
  List<Object> get props => [transactions];
}

class TransactionError extends TransactionState {
  final String message;

  const TransactionError({required this.message});

  @override
  List<Object> get props => [message];
}

class AddTransactionInitial extends TransactionState {}

class AddTransactionLoading extends TransactionState {}

class AddTransactionSuccess extends TransactionState {}

class AddTransactionFailure extends TransactionState {
  final String error;

  const AddTransactionFailure({required this.error});
}

class TransactionCancelled extends TransactionState {}
