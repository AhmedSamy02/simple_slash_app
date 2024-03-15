class ProductDetailsStates {}

class ProductDetailsInitialState extends ProductDetailsStates {}

class ProductDetailsLoadingState extends ProductDetailsStates {}

class ProductDetailsSuccessState extends ProductDetailsStates {
  int id;
  ProductDetailsSuccessState(this.id);
}

class ProductDetailsErrorState extends ProductDetailsStates {}
