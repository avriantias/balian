import 'dart:async';

import 'package:balian/models/addAddress_model.dart';
import 'package:balian/models/address_model.dart';
import 'package:balian/services/address_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'address_event.dart';
part 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final AddressService addressService;

  AddressBloc({required this.addressService}) : super(AddressInitial()) {
    on<FetchAddressesEvent>(_onFetchAddressesEvent);
    on<AddAddressEvent>(_onAddAddress);
    on<EditAddressEvent>(_onEditAddress);
    on<DeleteAddressEvent>(_onDeleteAddress);
  }

  Future<void> _onFetchAddressesEvent(
    FetchAddressesEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    try {
      final addresses = await addressService.getAddresses();
      emit(AddressLoaded(addresses));
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching addresses: $e'); // Log error
      emit(AddressError('Failed to load addresses: $e'));
    }
  }

  Future<void> _onAddAddress(
      AddAddressEvent event, Emitter<AddressState> emit) async {
    emit(AddressLoading());
    try {
      // Memanggil fungsi untuk menambahkan alamat
      await addressService.addAddress(event.address, event.token);
      emit(AddressAddSuccess());
    } catch (e) {
      // Cek tipe error
      emit(const AddressAddFailure('Gagal menambahkan alamat. Coba lagi.'));
    }
  }

  Future<void> _onEditAddress(
      EditAddressEvent event, Emitter<AddressState> emit) async {
    emit(AddressLoading()); // Start loading state
    try {
      final addressModel = AddressModel(
        id: event.id,
        userId: event.userId,
        subDistrictId: event.subDistrictId,
        address: event.address,
        type: event.type,
        receiverName: event.receiverName,
        receiverPhone: event.receiverPhone,
        status: event.status,
      );

      await addressService.editAddress(
          addressModel.id, addressModel, "your_token");
      emit(AddressEditSuccess());
    } catch (e) {
      emit(const AddressEditFailure('Failed to update address. Try again.'));
    }
  }

  Future<void> _onDeleteAddress(
    DeleteAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading()); // Menampilkan loading saat penghapusan
    try {
      // Menghapus alamat berdasarkan ID
      await addressService.deleteAddress(event.addressId);

      // Setelah berhasil dihapus, mengambil daftar alamat terbaru
      final updatedAddresses = await addressService.getAddresses();
      emit(AddressLoaded(
          updatedAddresses)); // Mengupdate daftar alamat setelah dihapus
    } catch (e) {
      emit(AddressError('Failed to delete address: $e')); // Menangani error
    }
  }
}
