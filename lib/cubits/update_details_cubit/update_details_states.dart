import 'package:flutter/material.dart';

class UpdateDetailsState {}

class UpdateDetailsInitialState extends UpdateDetailsState {}

class UpdateDetailsLoadingState extends UpdateDetailsState {}

class UpdateDetailsSuccessState extends UpdateDetailsState {
  Color color;
  UpdateDetailsSuccessState(
    this.color,
  );
}

class UpdateDetailsErrorState extends UpdateDetailsState {}
