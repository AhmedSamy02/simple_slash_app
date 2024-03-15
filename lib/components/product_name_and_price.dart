import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_slash_app/cubits/product_details/product_details_cubit.dart';
import 'package:simple_slash_app/cubits/product_details/product_details_states.dart';
import 'package:simple_slash_app/cubits/update_price_details_cubit/update_price_details_cubit.dart';
import 'package:simple_slash_app/cubits/update_price_details_cubit/update_price_details_states.dart';
import 'package:simple_slash_app/models/product.dart';

class ProductNameAndPrice extends StatelessWidget {
  const ProductNameAndPrice({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Text(
              product.name!,
              style: GoogleFonts.roboto(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<UpdatePriceDetailsCubit, UpdatePriceDetailsState>(
            builder: (context, state) {
              if (state is UpdatePriceDetailsInitialState) {
                return Text(
                  'EGP ${product.variations![0].price}',
                  style: GoogleFonts.roboto(
                    fontSize: 17.0,
                    color: Colors.white,
                  ),
                );
              } else if (state is UpdatePriceDetailsSuccessState) {
                for (var variation in product.variations!) {
                  if (variation.id == state.id) {
                    return Text(
                      'EGP ${variation.price}',
                      style: GoogleFonts.roboto(
                        fontSize: 17.0,
                        color: Colors.white,
                      ),
                    );
                  }
                }
              }
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }
}
