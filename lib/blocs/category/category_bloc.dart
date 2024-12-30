// // category_bloc.dart
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'category_event.dart';
// import 'category_state.dart';
// import 'package:balian/models/category_model.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:balian/shared/shared_values.dart'; // Import shared_value.dart

// class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
//   CategoryBloc() : super(CategoryInitial());

//   Stream<CategoryState> mapEventToState(CategoryEvent event) async* {
//     if (event is FetchCategoryData) {
//       yield CategoryLoading();
//       try {
//         final response = await http.get(Uri.parse('$baseUrl/categories'));

//         if (response.statusCode == 200) {
//           List<CategoryModel> categories = (json.decode(response.body) as List)
//               .map((data) => CategoryModel.fromJson(data))
//               .toList();
//           yield CategoryLoaded(categories);
//         } else {
//           yield CategoryError('Gagal memuat kategori');
//         }
//       } catch (e) {
//         yield CategoryError('Terjadi kesalahan: $e');
//       }
//     }
//   }
// }
