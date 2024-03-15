import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_slash_app/constants.dart';
import 'package:simple_slash_app/models/product.dart';

class BrandDetails extends StatelessWidget {
  const BrandDetails({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CachedNetworkImage(
          imageUrl: product.brand!.logo!,
          imageBuilder: (context, imageProvider) => Container(
            width: 60.0,
            height: 60.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
          placeholder: (context, url) => const SpinKitSpinningLines(
            color: Colors.white,
            size: 20,
          ),
          errorWidget: (context, url, error) => const CircleAvatar(
            backgroundColor: Colors.black,
            foregroundImage: AssetImage(
              kBrandLogo,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: SizedBox(
            width: 120,
            child: Text(
              product.brand!.name!,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: 14.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
