import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:balian/blocs/cart/cart_bloc.dart';
import 'package:balian/blocs/cart/cart_event.dart';
import 'package:balian/blocs/cart/cart_state.dart';
import 'package:balian/blocs/product/product_bloc.dart';
import 'package:balian/models/category_model.dart';
import 'package:balian/models/product_model.dart';
import 'package:balian/shared/theme.dart';
import 'package:balian/views/widgets/buttons.dart';
import 'package:balian/views/widgets/home_category.dart';
import 'package:balian/views/widgets/home_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = '';
  int activeIndex = 0;

  String formatCurrency(double price) {
    final NumberFormat formatter = NumberFormat('#,###', 'id_ID');
    return formatter.format(price.toInt());
  }

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(ProductGetAll());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartBloc, CartState>(
      listener: (context, state) {
        if (state is CartSuccess) {
          AnimatedSnackBar.material(
            state.message,
            type: AnimatedSnackBarType.error,
          ).show(context);
        } else if (state is CartFailure) {
          AnimatedSnackBar.material(
            state.error,
            type: AnimatedSnackBarType.success,
          ).show(context);
        }
      },
      child: Scaffold(
        backgroundColor: greyOpBackgroundColor,
        body: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(
                  child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xff33CC33)),
              ));
            } else if (state is ProductSuccess) {
              final categories = state.category;
              final products = state.product;

              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  Container(
                    alignment: Alignment.bottomLeft,
                    padding: const EdgeInsets.only(top: 50, bottom: 10),
                    child: SizedBox(
                      height: 35,
                      child: Image.asset('assets/appbar_logo.png'),
                    ),
                  ),
                  buildBanner(categories),
                  buildSearch(),
                  buildCategory(categories),
                  _buildProductWidget(categories, products),
                ],
              );
            }
            return const Center(child: Text('Unknown state'));
          },
        ),
      ),
    );
  }

  Widget buildBanner(List<CategoryModel> categories) {
    return Container(
      width: 395,
      height: 132,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: NetworkImage(categories[activeIndex].banner),
        ),
      ),
    );
  }

  Widget buildSearch() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: 45,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            searchQuery = value.toLowerCase();
          });
        },
        decoration: InputDecoration(
          hintText: 'Cari produk..',
          hintStyle: greyTextStyle.copyWith(
            fontSize: 14,
            fontWeight: medium,
          ),
          suffixIcon: const Icon(Icons.search, color: Colors.grey),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: greenColor),
            borderRadius: BorderRadius.circular(10),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        ),
      ),
    );
  }

  Widget buildCategory(List<CategoryModel> categories) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kategori',
            style: blackTextStyle.copyWith(
              fontSize: 18,
              fontWeight: semibold,
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(categories.length, (index) {
                return HomeCategory(
                  imageUrl: categories[index].image,
                  title: categories[index].name,
                  isActive: activeIndex == index,
                  onTap: () {
                    setState(() {
                      activeIndex = index;
                    });
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductWidget(
      List<CategoryModel> categories, List<ProductModel> products) {
    final activeCategory =
        categories.isNotEmpty ? categories[activeIndex] : null;

    final filteredByCategory = activeIndex == 0
        ? products
        : (activeCategory != null
            ? products
                .where((product) => product.categoryId == activeCategory.id)
                .toList()
            : []);

    final filteredProducts = searchQuery.isNotEmpty
        ? filteredByCategory
            .where(
                (product) => product.name.toLowerCase().contains(searchQuery))
            .toList()
        : filteredByCategory;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Produk ${activeCategory != null ? activeCategory.name : 'Semua Produk'}',
          style: blackTextStyle.copyWith(
            fontSize: 18,
            fontWeight: semibold,
          ),
        ),
        const SizedBox(height: 20),
        GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 0.65,
          ),
          itemCount: filteredProducts.length,
          itemBuilder: (context, index) {
            final product = filteredProducts[index];

            if (product.variants.isNotEmpty) {
              final price = product.variants[0].price;
              final priceDouble = price.toDouble();
              final allVariants = product.variants.map<String>((variant) {
                return variant.name?.toString() ??
                    ''; // Mengkonversi ke String jika perlu
              }).toList();

              final variantString = allVariants.join(', ');

              return HomeProduct(
                name: product.name,
                imageUrl: product.thumbnail,
                price: priceDouble,
                variant: variantString,
                onTap: () => showProductDetail(
                  context,
                  product,
                  allVariants, // Kirim sebagai List<String>
                  product.variants, // Kirim sebagai raw variants
                ),
              );
            } else {
              return const Center(child: Text('Produk Tidak Tersedia'));
            }
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  void showProductDetail(
    BuildContext context,
    ProductModel product,
    List<String> variantList,
    List<Variant> rawVariants, // Variants raw data
  ) {
    int quantity = 1;

    Variant selectedVariant = product.variants.isNotEmpty
        ? product.variants[0]
        : Variant(
            id: 0,
            productId: product.id,
            name: '',
            price: 0,
            isVisible: 0,
            isSayur: 0,
            availableStockCount: 0,
            variantStocks: [],
          );

    showModalBottomSheet(
      backgroundColor: lightBackgroundColor,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.network(product.thumbnail, width: 60, height: 60),
                      const SizedBox(width: 16),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: blackTextStyle.copyWith(
                                fontSize: 18,
                                fontWeight: bold,
                              ),
                            ),
                            Text(
                              variantList.join(', '),
                              style: greyTextStyle.copyWith(
                                fontSize: 12,
                                fontWeight: semibold,
                              ),
                            ),
                            Text(
                              "Rp. ${formatCurrency(selectedVariant.price.toDouble())}",
                              style: blackTextStyle.copyWith(
                                fontSize: 15,
                                fontWeight: bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Pilih Varian",
                    style: blackTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: semibold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    runSpacing: 10,
                    children: [
                      for (var variant in variantList)
                        GestureDetector(
                          onTap: () {
                            setModalState(() {
                              selectedVariant = rawVariants.firstWhere(
                                (v) => v.name == variant,
                                orElse: () => Variant(
                                  id: 0,
                                  productId: product.id,
                                  name: variant,
                                  price: 0,
                                  isVisible: 0,
                                  isSayur: 0,
                                  availableStockCount: 0,
                                  variantStocks: [],
                                ),
                              );
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: selectedVariant.name == variant
                                  ? greenColor
                                  : greyOpacityColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              variant,
                              style: TextStyle(
                                color: selectedVariant.name == variant
                                    ? whiteColor
                                    : blackColor,
                                fontFamily:
                                    GoogleFonts.plusJakartaSans().fontFamily,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Pilih Jumlah",
                        style: blackTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: semibold,
                        ),
                      ),
                      Container(
                        height: 34,
                        decoration: BoxDecoration(
                          color: greenBackgroundColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (quantity > 1) {
                                  setModalState(() {
                                    quantity--;
                                  });
                                }
                              },
                              icon: Icon(
                                Icons.remove,
                                size: 16,
                                color: greenColor,
                              ),
                            ),
                            Text(
                              "$quantity",
                              style: blackTextStyle.copyWith(
                                fontSize: 12,
                                fontWeight: semibold,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setModalState(() {
                                  quantity++;
                                });
                              },
                              icon: Icon(
                                Icons.add,
                                size: 16,
                                color: greenColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CustomFilledButton(
                    title: 'Tambah Ke Keranjang',
                    onPressed: () {
                      context.read<CartBloc>().add(
                            AddToCartEvent(
                              variantId: selectedVariant.id,
                              quantity: quantity,
                            ),
                          );
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
