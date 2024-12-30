import 'package:balian/models/category_model.dart';
import 'package:balian/models/home.dart';
import 'package:balian/models/product_model.dart';
import 'package:balian/services/home_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitial()) {
    on<ProductEvent>((event, emit) async {
      if (event is ProductGetAll) {
        try {
          emit(ProductLoading());

          HomeModel res = await ProductServices().getAllProduct();

          emit(ProductSuccess(res.product!, res.category!));
        } catch (e) {
          emit(ProductFailed(e.toString()));
        }
      }
    });
  }
}
