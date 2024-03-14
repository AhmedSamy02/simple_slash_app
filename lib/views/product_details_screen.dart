import 'package:accordion/accordion.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_slash_app/components/description_bar.dart';
import 'package:simple_slash_app/components/image_preveiwer_row.dart';
import 'package:simple_slash_app/components/list_of_tags.dart';
import 'package:simple_slash_app/components/select_text_header.dart';
import 'package:simple_slash_app/constants.dart';
import 'package:simple_slash_app/models/product.dart';
import 'package:simple_slash_app/services/get_product_by_id.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _id = 0;
  final SwiperController _swiperController = SwiperController();
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _id = ModalRoute.of(context)!.settings.arguments as int;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.black,
        title: Text(
          'Product Details',
          style: GoogleFonts.notoSansTangsa(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Product>(
        future: GetProductById.getProductById(_id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SpinKitFadingCube(
                color: Colors.white,
                size: 20,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: GoogleFonts.roboto(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
            );
          } else {
            var product = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  ImagesPreviewerRow(
                      swiperController: _swiperController,
                      images: product.variations![0].images!),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
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
                              child: Text(
                                'EGP ${product.variations![0].price}',
                                style: GoogleFonts.roboto(
                                  fontSize: 17.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            CachedNetworkImage(
                              imageUrl: product.brand!.logo!,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: 60.0,
                                height: 60.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                              placeholder: (context, url) =>
                                  const SpinKitSpinningLines(
                                color: Colors.white,
                                size: 20,
                              ),
                              errorWidget: (context, url, error) =>
                                  const CircleAvatar(
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
                        ),
                      ],
                    ),
                  ),
                  product.colors == null
                      ? const SizedBox()
                      : Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: SelectTextHeader(head: 'Color'),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: ColorHorizontalList(
                                position: 0,
                                colors: product.colors!.keys.toList(),
                              ),
                            )
                          ],
                        ),
                  product.sizes == null
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const SelectTextHeader(head: 'Size'),
                              ListOfTags(
                                tags: product.sizes!.keys.toList(),
                              ),
                            ],
                          ),
                        ),
                  product.materials == null
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const SelectTextHeader(head: 'Material'),
                              ListOfTags(
                                  tags: product.materials!.keys.toList()),
                            ],
                          ),
                        ),
                  product.description == null || product.description == ''
                      ? const SizedBox()
                      : DescriptionBar(
                          text: product.description!,
                        ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}


class ColorHorizontalList extends StatefulWidget {
  const ColorHorizontalList({
    super.key,
    required this.position,
    required this.colors,
  });
  final int position;
  final List<Color> colors;
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
          setState(() {
            _position = position;
          });
        },
        decorator: DotsDecorator(
          size: const Size.fromRadius(11),
          activeSize: const Size.fromRadius(12),
          spacing: const EdgeInsets.all(5),
          activeColors: widget.colors,
          colors: widget.colors,
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


