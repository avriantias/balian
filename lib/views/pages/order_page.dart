import 'package:balian/blocs/transaction/transaction_bloc.dart';
import 'package:balian/models/transaction_model.dart';
import 'package:balian/shared/theme.dart';
import 'package:balian/views/pages/bottomnavigation_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  final List<Map<String, dynamic>> transactions = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });

    // Memicu fetch transaksi saat halaman di-load
    final transactionBloc = context.read<TransactionBloc>();
    transactionBloc.add(const FetchTransactionsEvent(token: ''));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Metode untuk memfilter transaksi berdasarkan status
  List<Map<String, dynamic>> filterTransactions(String status) {
    return transactions
        .where((transaction) => transaction['status'] == status)
        .toList();
  }

  String formatCurrency(double price) {
    final NumberFormat formatter = NumberFormat.currency(
        locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);
    return formatter.format(price);
  }

  Widget _buildTabIcon(String activeImage, String inactiveImage, int index) {
    return Image.asset(
      _currentIndex == index ? activeImage : inactiveImage,
      width: 24,
      height: 24,
    );
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
          icon: Image.asset(
            'assets/ic_back_page.png',
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/bottomnavigation-page');
          },
        ),
        centerTitle: true,
        title: Text(
          'Pesanan Saya',
          style: blackTextStyle.copyWith(
            fontSize: 22,
            fontWeight: semibold,
          ),
        ),
      ),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return const Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff33CC33)),
            ));
          } else if (state is TransactionLoaded) {
            return _buildContent(state.transactions);
          } else if (state is TransactionError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text("Tidak ada data transaksi"));
        },
      ),
    );
  }

  Widget _buildContent(List<TransactionItemModel> transactions) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Column(
        children: [
          Container(
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
              children: [
                Text(
                  'Order Tracking',
                  style: blackTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: bold,
                  ),
                ),
                TabBar(
                  controller: _tabController,
                  unselectedLabelColor: greyColor,
                  labelColor: greenColor,
                  dividerColor: Colors.transparent,
                  indicatorColor: Colors.transparent,
                  tabs: [
                    Tab(
                      icon: _buildTabIcon('assets/icon_diorder_active.png',
                          'assets/icon_diorder.png', 0),
                      child: const Text(
                        'Diproses',
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                    Tab(
                      icon: _buildTabIcon('assets/icon_dikirim_active.png',
                          'assets/icon_dikirim.png', 1),
                      child: const Text(
                        'Dikirim',
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                    Tab(
                      icon: _buildTabIcon('assets/icon_selesai_active.png',
                          'assets/icon_selesai.png', 2),
                      child: const Text(
                        'Selesai',
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                    Tab(
                      icon: _buildTabIcon('assets/icon_dibatalkan_active.png',
                          'assets/icon_dibatalkan.png', 3),
                      child: const Text(
                        'Dibatalkan',
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                  // indicator: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(80.0),
                  //   color: greenColor.withOpacity(0.2),
                  // ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTransactionCard('processing', transactions),
                _buildTransactionCard('shipped', transactions),
                _buildTransactionCard('done', transactions),
                _buildTransactionCard('cancelled', transactions),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(
      String status, List<TransactionItemModel> transactions) {
    final filteredTransactions = transactions.where((t) {
      if (status == 'processing') {
        return t.status == 'processing' || t.status == 'pending';
      } else if (status == 'shipped') {
        return t.status == 'shipped' || t.status == 'delivered';
      }
      return t.status == status;
    }).toList();

    if (filteredTransactions.isEmpty) {
      return Center(
        child: Text('Tidak ada transaksi $status'),
      );
    }

    return ListView.builder(
      itemCount: filteredTransactions.length,
      itemBuilder: (context, index) {
        final transaction = filteredTransactions[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
          child: _buildTransactionContainer(transaction),
        );
      },
    );
  }

  Widget _buildTransactionContainer(TransactionItemModel transaction) {
    final isExpanded =
        transaction.isExpanded; // Adapt sesuai dengan TransactionItemModel
    return Container(
      padding: const EdgeInsets.all(5),
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
          _buildTransactionHeader(transaction),
          if (isExpanded) _buildTransactionDetails(transaction),
          _buildToggleButton(transaction),
        ],
      ),
    );
  }

  Widget _buildTransactionHeader(TransactionItemModel transaction) {
    String formattedDate =
        DateFormat('dd-MM-yyyy / hh:mm WIB').format(transaction.createdAt);
    String capitalize(String input) {
      if (input.isEmpty) return input;
      return input[0].toUpperCase() + input.substring(1).toLowerCase();
    }

    String serviceMethod = transaction.shippingMethodId.toString();

    Map<String, String> serviceNames = {
      "1": "Reguler",
      "2": "Express",
      "3": "Instan",
    };

    String serviceName = serviceNames[serviceMethod] ??
        "Unknown"; // Default jika ID tidak ditemukan

    TextStyle getTextStyle(String status) {
      if (status == 'pending') {
        return orangeTextStyle;
      } else if (status == 'processing' ||
          status == 'shipped' ||
          status == 'delivered' ||
          status == 'done') {
        return greenTextStyle;
      } else if (status == 'cancelled') {
        return redTextStyle;
      }
      return blackTextStyle; // Default style jika tidak ada yang sesuai
    }

    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 58,
            height: 18,
            decoration: BoxDecoration(
              color: greenColor,
              border: Border.all(
                color: greenColor,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              serviceName,
              textAlign: TextAlign.center,
              style: whiteTextStyle.copyWith(fontSize: 10, fontWeight: bold),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            'Kode Transaksi: ${transaction.code}',
            style: blackTextStyle.copyWith(fontSize: 13, fontWeight: semibold),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Waktu Transaksi: $formattedDate',
            style: greyTextStyle.copyWith(fontSize: 10, fontWeight: semibold),
          ),
          Text(
            'Total Bill: ${formatCurrency(transaction.totalPrice.toDouble() + double.parse(transaction.additionalCost) + transaction.shippingPrice.toDouble())}',
            style: blackTextStyle.copyWith(fontSize: 12, fontWeight: bold),
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
      trailing: Text(
        capitalize(transaction.status),
        style: getTextStyle(transaction.status).copyWith(
          fontWeight:
              bold, // Menjaga agar tetap menggunakan fontWeight yang sama
        ),
      ),
    );
  }

  Widget _buildTransactionDetails(TransactionItemModel transaction) {
    String? notes = transaction.notes;
    String displayNotes = notes ?? '-';
    String formattedDate =
        DateFormat('dd-MM-yyyy / hh:mm WIB').format(transaction.createdAt);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Daftar Produk
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transaction.details.length,
            itemBuilder: (context, index) {
              var detail = transaction.details[index];
              var variant = detail.variant;
              var product = variant.product;
              return _buildProductItem(transaction, product, variant, detail);
            },
          ),
          const Divider(thickness: 1.0),

          _buildSummaryRow(
              'Biaya Layanan', formatCurrency(transaction.appFee.toDouble())),
          _buildSummaryRow('Biaya Tambahan',
              formatCurrency(double.parse(transaction.additionalCost))),
          _buildSummaryRow('Biaya Pengiriman',
              formatCurrency(transaction.shippingPrice.toDouble())),
          const Divider(thickness: 1.0),
          _buildSummaryRow(
            'Total',
            formatCurrency(
              transaction.totalPrice.toDouble() +
                  double.parse(transaction.additionalCost) +
                  transaction.shippingPrice.toDouble(),
            ),
          ),
          // Informasi Tambahan
          const Divider(thickness: 1.0),

          // Informasi Tambahan
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: greyOpBackgroundColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Catatan: ',
                  style: blackTextStyle.copyWith(
                    fontSize: 13,
                    fontWeight: extrabold,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  displayNotes,
                  style: blackTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: semibold,
                  ),
                ),
                const SizedBox(height: 8.0),
              ],
            ),
          ),
          const SizedBox(height: 16.0),

          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: greyOpBackgroundColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Alamat Pengiriman: ',
                  style: blackTextStyle.copyWith(
                    fontSize: 13,
                    fontWeight: extrabold,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  transaction.address,
                  style: blackTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: semibold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Kode Transaksi',
                      style: blackTextStyle.copyWith(
                        fontSize: 12,
                        fontWeight: semibold,
                      ),
                    ),
                    Text(
                      transaction.code,
                      style: blackTextStyle.copyWith(
                        fontSize: 12,
                        fontWeight: semibold,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order Time',
                      style: blackTextStyle.copyWith(
                        fontSize: 12,
                        fontWeight: semibold,
                      ),
                    ),
                    Text(
                      formattedDate,
                      style: blackTextStyle.copyWith(
                        fontSize: 12,
                        fontWeight: semibold,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Metode Pembayaran',
                      style: blackTextStyle.copyWith(
                        fontSize: 12,
                        fontWeight: semibold,
                      ),
                    ),
                    Text(
                      'COD / Transfer',
                      style: blackTextStyle.copyWith(
                        fontSize: 12,
                        fontWeight: semibold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(TransactionItemModel transaction, Product product,
      Variant variant, Detail detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.network(
                product.thumbnail,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 8.0),
              Text(
                product.name,
                style:
                    blackTextStyle.copyWith(fontSize: 12, fontWeight: semibold),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatCurrency(variant.price.toDouble()),
                style:
                    blackTextStyle.copyWith(fontSize: 12, fontWeight: semibold),
              ),
              Text(
                'x${detail.quantity}',
                style:
                    greyTextStyle.copyWith(fontSize: 10, fontWeight: semibold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: blackTextStyle.copyWith(fontSize: 12, fontWeight: semibold),
        ),
        Text(
          value,
          style: blackTextStyle.copyWith(fontSize: 12, fontWeight: semibold),
        ),
      ],
    );
  }

  Widget _buildToggleButton(TransactionItemModel transaction) {
    final isExpanded = transaction.isExpanded;
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    Future<String?> getToken() async {
      return await secureStorage.read(key: 'token');
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (transaction.status == 'pending')
            Container(
              width: 58,
              height: 21,
              decoration: BoxDecoration(
                color: redColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: TextButton(
                onPressed: () async {
                  // Mengambil token dari SecureStorage
                  final token = await getToken();

                  if (token != null) {
                    // ignore: use_build_context_synchronously
                    final transactionBloc = context.read<TransactionBloc>();
                    transactionBloc.add(
                      CancelTransactionEvent(
                        transactionId: transaction.id.toString(),
                        token: token,
                      ),
                    );

                    transactionBloc.add(
                      FetchTransactionsEvent(
                          token:
                              token), // Ambil transaksi terbaru setelah cancel
                    );

                    Navigator.push(
                      // ignore: use_build_context_synchronously
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const BottomnavigationPage(initialIndex: 2),
                      ),
                    );
                  } else {
                    // Tampilkan pesan error jika token tidak ditemukan
                  }
                },
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Text(
                  'Cancel',
                  style: whiteTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: bold,
                  ),
                ),
              ),
            ),
          const SizedBox(
            width: 20,
          ),
          Container(
            width: 58,
            height: 21,
            decoration: BoxDecoration(
              border: Border.all(
                color: isExpanded ? redColor : greenColor,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: TextButton(
              onPressed: () {
                setState(() {
                  transaction.isExpanded = !isExpanded;
                });
              },
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: Text(
                isExpanded ? 'Tutup' : 'Detail',
                style: orangeTextStyle.copyWith(
                  fontSize: 12,
                  fontWeight: regular,
                  color: isExpanded ? redColor : greenColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16.0),
        ],
      ),
    );
  }
}
