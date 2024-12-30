import 'package:balian/models/addTransaction_model.dart';
import 'package:balian/models/transaction_model.dart';
import 'package:balian/services/transaction_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionService transactionService;

  TransactionBloc({required this.transactionService})
      : super(TransactionInitial()) {
    on<AddTransactionEvent>((event, emit) => addTransaction(event, emit));
    on<FetchTransactionsEvent>(_fetchTransactions);
    on<CancelTransactionEvent>(cancelTransaction);
  }

  // Fungsi untuk menambahkan transaksi
  Future<void> addTransaction(
    AddTransactionEvent event,
    Emitter<TransactionState> emit, // Menambahkan parameter emit
  ) async {
    emit(AddTransactionLoading()); // Mulai loading

    try {
      bool success =
          await transactionService.createTransaction(event.transaction);
      if (success) {
        emit(AddTransactionSuccess()); // Transaksi berhasil
      } else {
        emit(
            const AddTransactionFailure(error: 'Failed to create transaction'));
      }
    } catch (e) {
      emit(AddTransactionFailure(error: e.toString())); // Menangani error
    }
  }

  Future<void> _fetchTransactions(
      FetchTransactionsEvent event, Emitter<TransactionState> emit) async {
    emit(TransactionLoading());
    try {
      final transactions = await _getTransactions(event.token);
      emit(TransactionLoaded(transactions: transactions));
    } catch (e) {
      emit(TransactionError(message: e.toString()));
    }
  }

  Future<List<TransactionItemModel>> _getTransactions(String token) async {
    return await transactionService.fetchTransactions(token);
  }

  Future<void> cancelTransaction(
    CancelTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading()); // Mulai loading

    try {
      bool success = await transactionService.cancelTransaction(
          event.transactionId, event.token);

      if (success) {
        emit(TransactionCancelled()); // Transaksi berhasil dibatalkan
      } else {
        emit(const TransactionError(message: 'Failed to cancel transaction'));
      }
    } catch (e) {
      emit(TransactionError(message: e.toString())); // Menangani error
    }
  }
}
