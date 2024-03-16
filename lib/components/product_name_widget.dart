import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';


class ProductNameWidget extends StatelessWidget {
  const ProductNameWidget({
    super.key,
    required this.productName,
  });

  final String productName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Text(
          productName,
          style: GoogleFonts.roboto(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
