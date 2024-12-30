// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'home_event.dart';
// import 'home_state.dart';
// import 'package:balian/services/home_service.dart';

// class HomeBloc extends Bloc<HomeEvent, HomeState> {
//   final HomeRepository repository;

//   HomeBloc({required this.repository}) : super(HomeInitial()) {
//     on<FetchHomeData>(_onFetchHomeData);
//   }

//   Future<void> _onFetchHomeData(
//       FetchHomeData event, Emitter<HomeState> emit) async {
//     emit(HomeLoading());
//     try {
//       final homeData = await repository.fetchHomeData();

//       if (homeData.data.banners.isEmpty &&
//           homeData.data.categories.isEmpty &&
//           homeData.data.products.isEmpty) {
//         emit(HomeError(message: "No data available"));
//       } else {
//         emit(HomeLoaded(
//           banners: homeData.data.banners,
//           categories: homeData.data.categories,
//           products: homeData.data.products,
//         ));
//       }
//     } catch (e) {
//       emit(HomeError(message: e.toString()));
//     }
//   }
// }
