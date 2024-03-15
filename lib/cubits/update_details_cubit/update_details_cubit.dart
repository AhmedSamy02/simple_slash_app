
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_slash_app/cubits/update_details_cubit/update_details_states.dart';

class UpdateDetailsCubit extends Cubit<UpdateDetailsState> {
  UpdateDetailsCubit() : super(UpdateDetailsInitialState());
}