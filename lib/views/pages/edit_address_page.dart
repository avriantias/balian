import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:balian/blocs/address/address_bloc.dart';
import 'package:balian/models/address_model.dart';
import 'package:balian/services/address_service.dart';
import 'package:balian/shared/theme.dart';
import 'package:balian/views/widgets/buttons.dart';
import 'package:balian/views/widgets/forms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditAddressPage extends StatefulWidget {
  final int addressId;
  const EditAddressPage({super.key, required this.addressId});

  @override
  State<EditAddressPage> createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String? selectedDistrict;
  String? selectedSubDistrict;
  String? selectedType;
  String? selectedStatus;
  List<Map<String, dynamic>> districts = [];
  List<Map<String, dynamic>> subDistricts = [];

  List<String> tipeAlamatList = ["home", "office", "other"];
  List<String> statusAlamatList = ["active", "inactive"];

  bool isLoadingDistricts = false;
  bool isLoadingSubDistricts = false;

  // Fetch districts and address details on init
  @override
  void initState() {
    super.initState();
    _fetchDistricts();
    _fetchAddressDetail();
  }

  Future<void> _fetchDistricts() async {
    try {
      var fetchedDistricts = await AddressService().getDistricts();
      setState(() {
        districts = fetchedDistricts;
      });
    } catch (e) {
      AnimatedSnackBar.material(
        'Gagal memuat distrik: $e',
        type: AnimatedSnackBarType.error,
        // ignore: use_build_context_synchronously
      ).show(context);
    }
  }

  void _updateSubDistricts(int districtId) {
    var district =
        districts.firstWhere((item) => item['districtId'] == districtId);
    setState(() {
      subDistricts = List<Map<String, dynamic>>.from(district['subdistricts']);
      selectedSubDistrict = null; // Reset pilihan subdistrict
    });
  }

  Future<void> _fetchAddressDetail() async {
    try {
      AddressModel addressDetail =
          await AddressService().getAddressById(widget.addressId);

      setState(() {
        nameController.text = addressDetail.receiverName;
        phoneController.text = addressDetail.receiverPhone;
        addressController.text = addressDetail.address;

        // Memastikan district ditemukan dengan benar
        var foundDistrict = districts.firstWhere(
          (district) {
            // Pastikan perbandingan tipe data sesuai
            return district['districtId'].toString() ==
                addressDetail.subDistrict?.districtId.toString();
          },
          orElse: () => {
            'districtName': 'Tidak ditemukan', // Jika tidak ditemukan
            'districtId': -1
          },
        );

        selectedDistrict = foundDistrict['districtName'] ??
            'Tidak ditemukan'; // Pastikan tidak null

        // Memastikan subdistrictId terpasang dengan benar
        selectedSubDistrict =
            addressDetail.subDistrict?.name ?? 'Tidak ditemukan';

        selectedType = addressDetail.type;
        selectedStatus = addressDetail.status;

        // Mengupdate subdistrict berdasarkan subDistrictId
        _updateSubDistricts(addressDetail.subDistrictId);
      });
    } catch (e) {
      AnimatedSnackBar.material(
        'Gagal memuat detail alamat: $e',
        type: AnimatedSnackBarType.error,
        // ignore: use_build_context_synchronously
      ).show(context);
    }
  }

  void _submitAddress(BuildContext context) {
    if (nameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        selectedDistrict != null &&
        selectedSubDistrict != null &&
        selectedType != null &&
        selectedStatus != null) {
      final subDistrictId = int.tryParse(selectedSubDistrict!);

      if (subDistrictId == null) {
        AnimatedSnackBar.material(
          'Subdistrict ID tidak valid.',
          type: AnimatedSnackBarType.error,
        ).show(context);
        return;
      }

      final addressEvent = EditAddressEvent(
        id: widget.addressId,
        userId: 0, // Ganti dengan userId yang valid
        subDistrictId: subDistrictId,
        address: addressController.text,
        type: selectedType!,
        receiverName: nameController.text,
        receiverPhone: phoneController.text,
        status: selectedStatus!,
      );

      context.read<AddressBloc>().add(addressEvent);
    } else {
      AnimatedSnackBar.material(
        'Semua field harus diisi!!!',
        type: AnimatedSnackBarType.error,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddressBloc, AddressState>(
      listener: (context, state) {
        if (state is AddressEditSuccess) {
          AnimatedSnackBar.material(
            'Alamat berhasil diedit!',
            type: AnimatedSnackBarType.success,
          ).show(context);
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/address-page',
            (route) => false, // Menghapus semua rute di stack
          );
        } else if (state is AddressError) {
          AnimatedSnackBar.material(
            'Gagal mengedit alamat: ${state.message}',
            type: AnimatedSnackBarType.error,
          ).show(context);
        }
      },
      child: Scaffold(
        backgroundColor: greyOpBackgroundColor,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0.0,
          backgroundColor: greyOpBackgroundColor,
          leading: IconButton(
            icon: Image.asset(
              'assets/ic_back_page.png',
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: Text(
            'Tambah Alamat',
            style: blackTextStyle.copyWith(
              fontSize: 22,
              fontWeight: semibold,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(
                bottom: 16,
                right: 3,
                left: 3,
              ),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama Penerima
                  const Text("Nama Penerima"),
                  const SizedBox(height: 8),
                  CustomFormField(
                    controller: nameController,
                    title: 'Nama Penerima',
                  ),

                  const SizedBox(height: 16),

                  // Nomor Telepon
                  const Text("Nomor Telepon Penerima"),
                  const SizedBox(height: 8),
                  CustomFormFieldNumber(
                    controller: phoneController,
                    title: 'Nomor Telepon Penerima',
                  ),
                  const SizedBox(height: 16),

                  // Kecamatan (District Dropdown)
                  const Text("Kecamatan"),
                  const SizedBox(height: 8),
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: greyOpBackgroundColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      ),
                      dropdownColor: greyOpBackgroundColor,
                      style: blackTextStyle,
                      hint: Text(isLoadingDistricts
                          ? 'Memuat District...'
                          : 'Pilih District'),
                      value: selectedDistrict != null &&
                              selectedDistrict != 'Tidak ditemukan'
                          ? selectedDistrict
                          : null, // Pastikan ada validitas untuk selectedDistrict
                      items: districts.map((district) {
                        return DropdownMenuItem<String>(
                          value: district['districtName'],
                          child: Text(district['districtName']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedDistrict = value;
                            selectedSubDistrict =
                                null; // Reset subdistrict ketika district berubah
                            int districtId = districts.firstWhere((item) =>
                                item['districtName'] == value)['districtId'];
                            _updateSubDistricts(
                                districtId); // Fetch subdistrict berdasarkan district
                          });
                        }
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Kelurahan (SubDistrict Dropdown)
                  const Text("Kelurahan"),
                  const SizedBox(height: 8),
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: greyOpBackgroundColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      ),
                      dropdownColor: greyOpBackgroundColor,
                      style: blackTextStyle,
                      hint: Text(isLoadingSubDistricts
                          ? 'Memuat SubDistrict...'
                          : 'Pilih SubDistrict'),
                      value: selectedSubDistrict, // Pastikan ada nilai
                      items: subDistricts.map((subDistrict) {
                        return DropdownMenuItem<String>(
                          value: subDistrict['id']
                              .toString(), // Gunakan ID sebagai value
                          child: Text(subDistrict['name']), // Tampilkan nama
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedSubDistrict =
                                value; // Simpan ID sebagai string
                          });
                        }
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Alamat Lengkap
                  const Text("Alamat Lengkap"),
                  const SizedBox(height: 8),
                  CustomFormField(
                    controller: addressController,
                    title: 'Masukan Alamat Lengkap',
                  ),

                  const SizedBox(height: 16),

                  // Tipe Alamat
                  // Tipe Alamat
                  const Text("Tipe Alamat"),
                  const SizedBox(height: 8),
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: greyOpBackgroundColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      ),
                      dropdownColor: greyOpBackgroundColor,
                      style: blackTextStyle,
                      hint: const Text('Pilih Item'),
                      value: selectedType, // Menggunakan selectedType
                      items: tipeAlamatList.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedType = newValue; // Mengupdate selectedType
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Status Alamat
                  const Text("Status Alamat"),
                  const SizedBox(height: 8),
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: greyOpBackgroundColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      ),
                      dropdownColor: greyOpBackgroundColor,
                      style: blackTextStyle,
                      hint: const Text('Pilih Item'),
                      value: selectedStatus, // Menggunakan selectedStatus
                      items: statusAlamatList.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedStatus =
                              newValue; // Mengupdate selectedStatus
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Tombol Simpan Alamat
                  CustomFilledButton(
                    title: 'Simpan Alamat',
                    onPressed: () {
                      _submitAddress(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
