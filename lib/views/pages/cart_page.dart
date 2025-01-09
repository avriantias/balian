import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:balian/blocs/cart/cart_bloc.dart';
import 'package:balian/blocs/cart/cart_event.dart';
import 'package:balian/blocs/cart/cart_state.dart';
import 'package:balian/blocs/transaction/transaction_bloc.dart';
import 'package:balian/models/addTransaction_model.dart';
import 'package:balian/models/cart_model.dart';
import 'package:balian/models/shippingMethod_model.dart';
import 'package:balian/shared/theme.dart';
import 'package:balian/views/pages/bottomnavigation_page.dart';
import 'package:balian/views/widgets/buttons.dart';
import 'package:balian/views/widgets/shippingMethodWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final TextEditingController notesController = TextEditingController();
  bool isSelectAll = false;
  List<CartItem> items = [];
  List<ShippingMethod> shippingMethods = [];
  ShippingMethod? selectedMethod;

  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(FetchCartItemsEvent());
  }

  // Fungsi untuk toggle 'Select All'
  void toggleSelectAll(bool? value) {
    setState(() {
      isSelectAll = value ?? false;
      for (var item in items) {
        item.isChecked = value ?? false;
      }
    });
  }

  // Fungsi untuk toggle checkbox item individual
  void toggleItemCheck(int index, bool value) {
    setState(() {
      items[index].isChecked = value;
    });
  }

  void deleteSelectedItems() {
    List<int> selectedItemIds =
        items.where((item) => item.isChecked).map((item) => item.id).toList();

    if (selectedItemIds.isNotEmpty) {
      context
          .read<CartBloc>()
          .add(DeleteCartItemsEvent(itemIds: selectedItemIds));
      // Bersihkan checkbox setelah penghapusan
      setState(() {
        for (var item in items) {
          item.isChecked = false;
        }
        isSelectAll = false;
      });
    } else {
      AnimatedSnackBar.material(
        'Silahkan pilih product yang ingin dihapus!',
        type: AnimatedSnackBarType.error,
      ).show(context);
    }
  }

  // Fungsi untuk menampilkan dialog konfirmasi
  void showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: greyOpBackgroundColor,
          title: Text(
            'Konfirmasi Pesanan',
            style: blackTextStyle.copyWith(
              fontSize: 16,
              fontWeight: bold,
            ),
          ),
          content: Text(
            'Apakah Anda yakin ingin memesan? Pastikan pesanan Anda sudah sesuai!',
            style: blackTextStyle.copyWith(
              fontSize: 14,
              fontWeight: medium,
            ),
          ),
          actions: <Widget>[
            Container(
              width: 58,
              height: 25,
              decoration: BoxDecoration(
                color: greyColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Menutup dialog
                },
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
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
                color: greenColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Menutup dialog
                  addTransaction(); // Menutup dialog
                },
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Text(
                  'Pesan',
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
  }

  Future<void> addTransaction() async {
    // Mendapatkan item yang dipilih
    List<int> checkedItemIds =
        items.where((item) => item.isChecked).map((item) => item.id).toList();

    // Membuat map untuk menyimpan jumlah item yang dipilih
    Map<String, int> quantities = {};
    for (var item in items) {
      if (item.isChecked) {
        quantities[item.id.toString()] = item.quantity;
      }
    }

    // Validasi: Jika tidak ada item yang dipilih
    if (checkedItemIds.isEmpty) {
      AnimatedSnackBar.material(
        'Silahkan pilih produk yang ingin dipesan!',
        type: AnimatedSnackBarType.error,
      ).show(context);
      return;
    }

    // Validasi: Pastikan metode pengiriman telah dipilih
    if (selectedMethod == null) {
      AnimatedSnackBar.material(
        'Silahkan pilih metode pengiriman!',
        type: AnimatedSnackBarType.error,
      ).show(context);
      return;
    }

    // Mengambil biaya layanan dari metode pengiriman yang dipilih
    final serviceFee = selectedMethod!.cost;

    // Menghitung total harga
    final double subtotal = items
        .where((item) => item.isChecked)
        .fold(0.0, (sum, item) => sum + (item.variant.price * item.quantity));

    final double totalPrice = subtotal + serviceFee;

    // Membuat model transaksi
    final transaction = TransactionModel(
      totalPrice: totalPrice.toInt(),
      checkedItems: checkedItemIds,
      quantities: quantities,
      shipping_method: selectedMethod!.id, // ID metode pengiriman
      shippingPrice: 0.toInt(), // Ubah jika ada ongkos kirim tambahan
      appFee: serviceFee, // Biaya layanan
      notes: notesController.text.trim(), // Catatan dari pengguna
    );

    // Debugging: Cetak data transaksi

    // Kirim transaksi ke BLoC
    context
        .read<TransactionBloc>()
        .add(AddTransactionEvent(transaction: transaction));

    // Simulasi hasil API (true = sukses, false = gagal)
    bool isSuccess = true;

    // Penanganan hasil transaksi
    if (isSuccess) {
      Navigator.pushNamed(context, '/pesananberhasil-page');
      AnimatedSnackBar.material(
        'Pesanan Berhasil Dibuat!',
        type: AnimatedSnackBarType.success,
      ).show(context);
      // ignore: dead_code
    } else {
      AnimatedSnackBar.material(
        'Gagal membuat pesanan. Silakan coba lagi!',
        type: AnimatedSnackBarType.error,
      ).show(context);
    }
  }

  String formatCurrency(double price) {
    final NumberFormat formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return formatter.format(price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyOpBackgroundColor,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0.0,
        backgroundColor: greyOpBackgroundColor,
        leading: IconButton(
          icon: Image.asset('assets/ic_back_page.png'),
          onPressed: () {
            Navigator.pushNamed(context, '/bottomnavigation-page');
          },
        ),
        centerTitle: true,
        title: Text(
          'Keranjang Belanja',
          style: blackTextStyle.copyWith(fontSize: 22, fontWeight: semibold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: BlocBuilder<CartBloc, CartState>(builder: (context, state) {
            if (state is CartLoading) {
              return const Column(
                children: [
                  SizedBox(
                    height: 300,
                  ),
                  Center(
                      child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xff33CC33)),
                  )),
                ],
              );
            } else if (state is CartItemsLoaded) {
              items = state.items;
              if (items.isEmpty) {
                // Tampilkan pesan dan tombol jika keranjang kosong
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/img_keranjang_kosong.png',
                          width: 175,
                          height: 175,
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Text(
                        'Yah Keranjangnya Kosong ',
                        style: blackTextStyle.copyWith(
                          fontSize: 22,
                          fontWeight: semibold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Yuk Belanja Sekarang',
                        style: blackTextStyle.copyWith(
                          fontSize: 14,
                          fontWeight: medium,
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      CustomFilledButton(
                          title: 'Belanja Sekarang',
                          width: 170,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const BottomnavigationPage(initialIndex: 0),
                              ),
                            );
                          })
                    ],
                  ),
                );
              }
              return Column(
                children: [
                  _buildHeaderSection(),
                  _buildProductList(),
                  _buildCardNote(notesController),
                  const SizedBox(height: 10),
                  ShippingMethodWidget(
                    shippingMethods: state.shippingMethods,
                    onMethodSelected: (method) {
                      setState(() {
                        selectedMethod = method;
                      });
                      // Misalnya: Simpan pilihan metode pengiriman dalam variabel atau state
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildOrderInfo(),
                  const SizedBox(height: 16),
                  CustomFilledButton(
                    title: 'Pesan Sekarang',
                    onPressed:
                        showConfirmationDialog, // Menampilkan dialog konfirmasi
                  ),
                  const SizedBox(height: 10),
                ],
              );
            } else if (state is CartFailure) {
              return Center(child: Text('Error: ${state.error}'));
            }
            return Container();
          }),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: isSelectAll,
              onChanged: toggleSelectAll,
              activeColor: const Color(0xff33CC33),
            ),
            Text(
              "Pilih Semua",
              style: blackTextStyle.copyWith(fontWeight: bold),
            ),
          ],
        ),
        GestureDetector(
          onTap: deleteSelectedItems,
          child: Text(
            "Hapus",
            style: redTextStyle,
          ),
        ),
      ],
    );
  }

  Widget _buildProductList() {
    return Column(
      children: items.map((item) => _buildProductCard(item)).toList(),
    );
  }

  Widget _buildProductCard(CartItem item) {
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
      child: Row(
        children: [
          Checkbox(
            value: item.isChecked,
            onChanged: (value) {
              toggleItemCheck(items.indexOf(item), value ?? false);
            },
            activeColor: greenColor,
          ),
          Image.network(
            item.variant.product.thumbnail,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.variant.product.name,
                  style: blackTextStyle.copyWith(fontWeight: bold),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  item.variant.name,
                  style:
                      greyTextStyle.copyWith(fontSize: 12, fontWeight: regular),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  formatCurrency(item.variant.price * item.quantity),
                  style: blackTextStyle.copyWith(
                      fontSize: 14, fontWeight: semibold),
                ),
              ],
            ),
          ),
          Container(
            height: 30,
            padding: const EdgeInsets.all(0.0),
            decoration: BoxDecoration(
              color: greenBackgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
                  constraints: const BoxConstraints(),
                  icon: Icon(Icons.remove, size: 12, color: greenColor),
                  onPressed: () {
                    setState(() {
                      if (item.quantity > 1) {
                        item.quantity--;
                      }
                    });
                  },
                ),
                Text(
                  item.quantity.toString(),
                  style: blackTextStyle.copyWith(
                      fontSize: 12, fontWeight: semibold),
                ),
                IconButton(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
                  constraints: const BoxConstraints(),
                  icon: Icon(Icons.add, size: 12, color: greenColor),
                  onPressed: () {
                    setState(() {
                      item.quantity++;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderInfo() {
    final double subtotal = items
        .where((item) => item.isChecked)
        .fold(0.0, (sum, item) => sum + (item.variant.price * item.quantity));

    final double serviceFee =
        selectedMethod != null ? selectedMethod!.cost.toDouble() : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: greenColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Order Info",
            style: whiteTextStyle.copyWith(fontSize: 16, fontWeight: bold),
          ),
          const SizedBox(height: 16),
          _buildOrderInfoRow("Subtotal", subtotal),
          const SizedBox(height: 8),
          _buildOrderInfoRow("Ongkos Kirim", 0),
          const SizedBox(height: 8),
          _buildOrderInfoRow("Biaya Layanan", serviceFee),
          const SizedBox(height: 8),
          const Divider(color: Colors.white),
          _buildOrderInfoRow("Total", subtotal + serviceFee, isBold: true),
        ],
      ),
    );
  }

  Widget _buildOrderInfoRow(String title, double value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: whiteTextStyle.copyWith(
              fontSize: 14, fontWeight: isBold ? bold : medium),
        ),
        Text(
          formatCurrency(value),
          style: whiteTextStyle.copyWith(
              fontSize: 14, fontWeight: isBold ? bold : medium),
        ),
      ],
    );
  }
}

Widget _buildCardNote(notesController) {
  return Column(
    children: <Widget>[
      Card(
        color: lightBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: notesController,
            maxLines: 3, //or null
            decoration: InputDecoration.collapsed(
              hintText:
                  "Tambahkan Catatan di sini....\nContoh: Tolong sekalian belikan bumbu langkok buat gulai, mohon pastikan sayur dan bumbu, dll",
              hintStyle: blackTextStyle.copyWith(fontSize: 12),
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      Card(
        color: lightBackgroundColor,
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.info_outline_rounded, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    'Catatan:',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 8),
              BulletPointText(
                text:
                    'Anda dapat menambahkan permintaan produk yang tidak tersedia di katalog kami',
              ),
              BulletPointText(
                text:
                    'Apabila ada permintaan khusus yang memerlukan biaya tambahan, akan diinformasikan oleh admin dan tidak termasuk dalam total pembayaran saat ini',
              ),
            ],
          ),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      Container(
        alignment: Alignment.centerLeft,
        child: Text(
          "Pilih Metode Pengiriman",
          textAlign: TextAlign.start,
          style: blackTextStyle.copyWith(fontSize: 14),
        ),
      ),
    ],
  );
}

class BulletPointText extends StatelessWidget {
  final String text;

  const BulletPointText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: blackTextStyle.copyWith(
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
