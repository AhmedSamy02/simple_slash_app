import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_slash_app/cubits/add_to_cart_cubit/add_to_cart_cubit.dart';
import 'package:simple_slash_app/cubits/add_to_cart_cubit/add_to_cart_states.dart';
import 'package:simple_slash_app/cubits/product_details/product_details_cubit.dart';
import 'package:simple_slash_app/cubits/product_details/product_details_states.dart';
import 'package:simple_slash_app/cubits/update_details_cubit/update_details_cubit.dart';
import 'package:simple_slash_app/cubits/update_details_cubit/update_details_states.dart';
import 'package:simple_slash_app/cubits/update_price_details_cubit/update_price_details_cubit.dart';
import 'package:simple_slash_app/cubits/update_price_details_cubit/update_price_details_states.dart';

class ColorHorizontalList extends StatefulWidget {
  const ColorHorizontalList({
    super.key,
    required this.position,
    required this.colors,
  });
  final int position;
  final Map<Color, List<int>> colors;
  @override
  State<ColorHorizontalList> createState() => _ColorHorizontalListState();
}

class _ColorHorizontalListState extends State<ColorHorizontalList> {
  int _position = 0;
  @override
  void initState() {
    super.initState();
    _position = widget.position;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DotsIndicator(
        dotsCount: widget.colors.length,
        position: _position,
        onTap: (position) {
          int index = widget.colors.values.elementAt(position).first;
          BlocProvider.of<UpdatePriceDetailsCubit>(context)
              .emit(UpdatePriceDetailsSuccessState(id: index));
          BlocProvider.of<ProductDetailsCubit>(context)
              .emit(ProductDetailsSuccessState(index));
          BlocProvider.of<UpdateDetailsCubit>(context).emit(
              UpdateDetailsSuccessState(
                  widget.colors.keys.elementAt(position)));
          BlocProvider.of<AddToCartCubit>(context).emit(AddToCartSuccess());

          setState(() {
            _position = position;
          });
        },
        decorator: DotsDecorator(
          size: const Size.fromRadius(11),
          activeSize: const Size.fromRadius(12),
          spacing: const EdgeInsets.all(5),
          activeColors: widget.colors.keys.toList(),
          colors: widget.colors.keys.toList(),
          shape: const CircleBorder(
            side: BorderSide(
              color: Colors.white12,
              width: 2,
              strokeAlign: 1,
            ),
          ),
          activeShape: const CircleBorder(
            side: BorderSide(
              strokeAlign: 3,
              color: Colors.white,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
