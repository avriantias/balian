part of 'address_bloc.dart';

abstract class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object> get props => [];
}

class AddressInitial extends AddressState {}

class AddressLoading extends AddressState {}

class AddressLoaded extends AddressState {
  final List<AddressModel> addresses;
  const AddressLoaded(this.addresses);

  @override
  List<Object> get props => [addresses];
}

class AddressAdding extends AddressState {}

class AddressAdded extends AddressState {}

class AddressError extends AddressState {
  final String message;

  const AddressError(this.message);

  @override
  List<Object> get props => [message];
}

class AddressAddSuccess extends AddressState {}

class AddressAddFailure extends AddressState {
  final String error;

  const AddressAddFailure(this.error);

  @override
  List<Object> get props => [error];
}

class AddressEditSuccess extends AddressState {}

class AddressEditFailure extends AddressState {
  final String message;
  const AddressEditFailure(this.message);

  @override
  List<Object> get props => [message];
}

class AddressErrorState extends AddressState {
  final String errorMessage;

  const AddressErrorState(this.errorMessage);
}

class AddressDeletedState extends AddressState {
  final List<AddressModel> updatedAddresses;

  const AddressDeletedState(this.updatedAddresses);

  @override
  List<Object> get props => [updatedAddresses];
}
