import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_slash_app/cubits/product_details/product_details_states.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsStates>{
  ProductDetailsCubit() : super(ProductDetailsInitialState());
  static ProductDetailsCubit get(context) => BlocProvider.of(context);
}