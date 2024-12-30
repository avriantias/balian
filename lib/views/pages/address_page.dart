import 'package:balian/blocs/address/address_bloc.dart';
import 'package:balian/views/pages/bottomnavigation_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balian/shared/theme.dart';
import 'package:balian/views/widgets/buttons.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  @override
  void initState() {
    super.initState();
    // Memanggil event setelah halaman pertama kali dibuka
    context.read<AddressBloc>().add(FetchAddressesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyOpBackgroundColor,
      appBar: AppBar(
        backgroundColor: greyOpBackgroundColor,
        leading: IconButton(
          icon: Image.asset('assets/ic_back_page.png'),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const BottomnavigationPage(
                    initialIndex: 3), // Sesuaikan initialIndex sesuai kebutuhan
              ),
              (route) => false, // Hapus semua rute sebelumnya
            );
          },
        ),
        centerTitle: true,
        title: Text(
          'Alamat Saya',
          style: blackTextStyle.copyWith(
            fontSize: 22,
            fontWeight: semibold,
          ),
        ),
      ),
      body: BlocBuilder<AddressBloc, AddressState>(
        builder: (context, state) {
          if (state is AddressLoading) {
            return const Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff33CC33)),
            ));
          } else if (state is AddressLoaded) {
            if (state.addresses.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Belum ada alamat, Silahkan tambahkan alamat.',
                      textAlign: TextAlign.center,
                      style: blackTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomFilledButton(
                      title: 'Tambah Alamat Baru',
                      onPressed: () {
                        Navigator.pushNamed(context, '/add-address-page');
                      },
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.addresses.length + 1,
              itemBuilder: (context, index) {
                if (index == state.addresses.length) {
                  return CustomFilledButton(
                    title: 'Tambah Alamat Baru',
                    onPressed: () {
                      Navigator.pushNamed(context, '/add-address-page');
                    },
                  );
                }

                final address = state.addresses[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16, right: 3, left: 3),
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
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            address.receiverName,
                            style: blackTextStyle.copyWith(
                              fontSize: 16,
                              fontWeight: medium,
                            ),
                          ),
                          Container(
                            width: 58,
                            height: 20,
                            decoration: BoxDecoration(
                              color: greenColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              address.type,
                              textAlign: TextAlign.center,
                              style: whiteTextStyle.copyWith(
                                fontWeight: bold,
                                fontSize: 12,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.call_outlined,
                            color: greyColor,
                            size: 16,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            address.receiverPhone,
                            style: greyTextStyle.copyWith(
                              fontSize: 13,
                              fontWeight: regular,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: greyColor,
                            size: 16,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '${address.address}, ${address.subDistrict?.name ?? '-'}, ${address.subDistrict?.districtInfo?.name ?? '-'}',
                              style: greyTextStyle.copyWith(
                                fontSize: 13,
                                fontWeight: regular,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 58,
                            height: 20,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: address.status == 'active'
                                    ? greenColor
                                    : redColor,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              address.status == 'active'
                                  ? 'Active'
                                  : 'Inactive',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: address.status == 'active'
                                    ? greenColor
                                    : redColor,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 120,
                          ),
                          Container(
                            width: 58,
                            height: 20,
                            decoration: BoxDecoration(
                              color: greenColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/edit-address-page', // Routes harus sesuai
                                  arguments: state.addresses[index]
                                      .id, // Mengirimkan addressId sebagai argument
                                );
                              },
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero),
                              child: Text(
                                'Edit',
                                style: whiteTextStyle.copyWith(
                                  fontSize: 12,
                                  fontWeight: bold,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 58,
                            height: 20,
                            decoration: BoxDecoration(
                              color: redColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: TextButton(
                              onPressed: () {
                                // Menampilkan dialog konfirmasi sebelum menghapus
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        'Konfirmasi',
                                        style: blackTextStyle.copyWith(
                                            fontSize: 16, fontWeight: bold),
                                      ),
                                      content: Text(
                                        'Apakah Anda yakin ingin menghapus alamat ini?',
                                        style: blackTextStyle.copyWith(
                                            fontSize: 14, fontWeight: medium),
                                      ),
                                      actions: <Widget>[
                                        Container(
                                          width: 58,
                                          height: 25,
                                          decoration: BoxDecoration(
                                            color: greyColor,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Menutup dialog
                                            },
                                            style: TextButton.styleFrom(
                                                padding: EdgeInsets.zero),
                                            child: Text(
                                              'Batal',
                                              style: whiteTextStyle.copyWith(
                                                fontSize: 12,
                                                fontWeight: bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 58,
                                          height: 25,
                                          decoration: BoxDecoration(
                                            color: redColor,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: TextButton(
                                            onPressed: () {
                                              // Menghapus alamat dengan memanggil event DeleteAddressEvent
                                              // Memanggil DeleteAddressEvent dengan addressId yang sesuai
                                              context.read<AddressBloc>().add(
                                                  DeleteAddressEvent(
                                                      address.id));
                                              Navigator.of(context)
                                                  .pop(); // Menutup dialog
                                            },
                                            style: TextButton.styleFrom(
                                                padding: EdgeInsets.zero),
                                            child: Text(
                                              'Hapus',
                                              style: whiteTextStyle.copyWith(
                                                fontSize: 12,
                                                fontWeight: bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero),
                              child: Text(
                                'Hapus',
                                style: whiteTextStyle.copyWith(
                                  fontSize: 12,
                                  fontWeight: bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is AddressError) {
            return const Center(child: Text('Failed to load addresses'));
          } else {
            return const Center(child: Text('No addresses found'));
          }
        },
      ),
    );
  }
}
