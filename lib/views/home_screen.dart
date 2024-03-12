import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numeral/numeral.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        surfaceTintColor: Colors.black,
        title: Text(
          'Slash.',
          style: GoogleFonts.notoSansTangsa(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        primary: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: GridView.builder(
          itemCount: 20,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 0.85, mainAxisSpacing: 20),
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(left: 20.0),
              color: Colors.black,
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: ProductCardImage(
                      imageURL:
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQYZkVHaCkd6Opc6l1aunktO2Y_ILQyPND4JwCnwWVP4w&s',
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12.0, left: 12),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Product Name - Addidas',
                              maxLines: 2,
                              style: GoogleFonts.roboto(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: CircleAvatar(
                              radius: 15,
                              backgroundImage: CachedNetworkImageProvider(
                                  "http://via.placeholder.com/350x150"),
                              backgroundColor: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text(
                            'EGP ' + 1000.numeral(),
                            style: GoogleFonts.roboto(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const Spacer(),
                        
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class ProductCardImage extends StatelessWidget {
  const ProductCardImage({
    super.key,
    required this.imageURL,
  });
  final String imageURL;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      width: MediaQuery.of(context).size.height/6,
      imageUrl: imageURL,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent, width: 2),
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.fill,
          ),
        ),
      ),
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          const SpinKitFadingFour(
        color: Colors.white,
      ),
      errorWidget: (context, url, error) => const Icon(
        Icons.error,
        color: Colors.white,
      ),
    );
  }
}
