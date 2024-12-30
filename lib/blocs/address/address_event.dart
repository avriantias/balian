part of 'address_bloc.dart';

abstract class AddressEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchAddressesEvent extends AddressEvent {}

class AddAddressEvent extends AddressEvent {
  final AddAddressModel address;
  final String token;

  AddAddressEvent(this.address, this.token);

  @override
  List<Object> get props => [address, token];
}

class EditAddressEvent extends AddressEvent {
  final int id;
  final int userId;
  final int subDistrictId;
  final String address;
  final String type;
  final String receiverName;
  final String receiverPhone;
  final String status;

  EditAddressEvent({
    required this.id,
    required this.userId,
    required this.subDistrictId,
    required this.address,
    required this.type,
    required this.receiverName,
    required this.receiverPhone,
    required this.status,
  });

  @override
  List<Object> get props => [
        id,
        userId,
        subDistrictId,
        address,
        type,
        receiverName,
        receiverPhone,
        status,
      ];
}

class DeleteAddressEvent extends AddressEvent {
  final int addressId;

  DeleteAddressEvent(this.addressId);

  @override
  List<Object> get props => [addressId];
}
