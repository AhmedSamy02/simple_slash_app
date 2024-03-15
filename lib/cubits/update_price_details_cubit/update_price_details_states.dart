class UpdatePriceDetailsState {}

class UpdatePriceDetailsInitialState extends UpdatePriceDetailsState {}

class UpdatePriceDetailsLoadingState extends UpdatePriceDetailsState {}

class UpdatePriceDetailsSuccessState extends UpdatePriceDetailsState {
  int? id;
  UpdatePriceDetailsSuccessState({this.id});
}

class UpdatePriceDetailsErrorState extends UpdatePriceDetailsState {}
