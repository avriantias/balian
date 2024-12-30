import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:balian/blocs/address/address_bloc.dart';
import 'package:balian/models/addAddress_model.dart';
import 'package:balian/services/address_service.dart';
import 'package:balian/shared/theme.dart';
import 'package:balian/views/widgets/buttons.dart';
import 'package:balian/views/widgets/forms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
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

  @override
  void initState() {
    super.initState();
    _fetchDistricts();
  }

  // Fetch data distrik dan subdistrict
  Future<void> _fetchDistricts() async {
    setState(() {
      isLoadingDistricts = true;
    });
    try {
      var fetchedDistricts = await AddressService().getDistricts();
      setState(() {
        districts = fetchedDistricts; // Mengupdate data distrik yang difetch
      });
      // ignore: empty_catches
    } catch (e) {
    } finally {
      setState(() {
        isLoadingDistricts = false;
      });
    }
  }

  // Ambil subdistrict berdasarkan district yang dipilih
  void _updateSubDistricts(int districtId) {
    var district =
        districts.firstWhere((item) => item['districtId'] == districtId);
    setState(() {
      subDistricts = List<Map<String, dynamic>>.from(district['subdistricts']);
      selectedSubDistrict = null; // Reset pilihan subdistrict
    });
  }

  void _submitAddress(BuildContext context) {
    if (nameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        selectedDistrict != null &&
        selectedSubDistrict != null &&
        selectedType != null &&
        selectedStatus != null) {
      // Konversi subdistrict ID ke integer
      final subDistrictId = int.tryParse(selectedSubDistrict!);

      if (subDistrictId == null) {
        AnimatedSnackBar.material(
          'Subdistrict ID tidak valid.',
          type: AnimatedSnackBarType.error,
        ).show(context);
        return;
      }

      // Membuat model alamat baru
      final address = AddAddressModel(
        name: nameController.text,
        phone: phoneController.text,
        address: addressController.text,
        district: selectedDistrict!,
        subDistrict: subDistrictId,
        type: selectedType!,
        status: selectedStatus!,
      );

      // Memicu event `AddAddressEvent` ke AddressBloc
      context.read<AddressBloc>().add(
            AddAddressEvent(address, 'TOKEN_BEARER'),
          );
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
        if (state is AddressAddSuccess) {
          // Menampilkan SnackBar berhasil
          AnimatedSnackBar.material(
            'Alamat berhasil ditambahkan!',
            type: AnimatedSnackBarType.success,
          ).show(context);

          // Navigasi ke halaman AddressPage
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/address-page',
            (route) => false, // Menghapus semua rute di stack
          );
        } else if (state is AddressError) {
          // ignore: avoid_print
          AnimatedSnackBar.material(
            'Gagal menambahkan alamat: ${state.message}',
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
                    title: '08 xxxx xxxx',
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
                      value: selectedDistrict,
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
                      value: selectedSubDistrict,
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
                                value; // Simpan ID (dalam bentuk string)
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
