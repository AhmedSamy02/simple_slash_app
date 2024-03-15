import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_slash_app/cubits/update_price_details_cubit/update_price_details_states.dart';

class UpdatePriceDetailsCubit extends Cubit<UpdatePriceDetailsState> {
  UpdatePriceDetailsCubit() : super(UpdatePriceDetailsInitialState());
}