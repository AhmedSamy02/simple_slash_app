import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_slash_app/cubits/add_to_cart_cubit/add_to_cart_states.dart';

class AddToCartCubit extends Cubit<AddToCartState> {
  AddToCartCubit() : super(AddToCartInitial());
}