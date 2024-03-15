import 'package:card_swiper/card_swiper.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_slash_app/components/brand_details.dart';
import 'package:simple_slash_app/components/color_image_list_view.dart';
import 'package:simple_slash_app/components/description_bar.dart';
import 'package:simple_slash_app/components/image_preveiwer_row.dart';
import 'package:simple_slash_app/components/list_of_tags.dart';
import 'package:simple_slash_app/components/product_name_and_price.dart';
import 'package:simple_slash_app/components/select_text_header.dart';
import 'package:simple_slash_app/cubits/product_details/product_details_cubit.dart';
import 'package:simple_slash_app/cubits/product_details/product_details_states.dart';
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
    return BlocProvider(
      create: (context) => ProductDetailsCubit(),
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.black,
          title: Text(
            'Product Details $_id',
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
                    BlocBuilder<ProductDetailsCubit, ProductDetailsStates>(
                      builder: (context, state) {
                        if (state is ProductDetailsInitialState) {
                          return ImagesPreviewerRow(
                              swiperController: _swiperController,
                              images: product.variations![0].images!);
                        } else if (state is ProductDetailsSuccessState) {
                          for (var variation in product.variations!) {
                            if (variation.id == state.id) {
                              return ImagesPreviewerRow(
                                  swiperController: _swiperController,
                                  images: variation.images!);
                            }
                          }
                        }
                        return const SizedBox();
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          ProductNameAndPrice(product: product),
                          const Spacer(),
                          BrandDetails(product: product),
                        ],
                      ),
                    ),
                    product.colorImages == null
                        ? const SizedBox()
                        : Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: SelectTextHeader(head: 'Color'),
                              ),
                              ColorImageListView(
                                  images:
                                      product.colorImages!.map((key, value) {
                                return MapEntry(
                                  key,
                                  value[0],
                                );
                              }))
                            ],
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
                                  colors: product.colors!,
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
                                  tags: {
                                    'S': 0,
                                    'M': 1,
                                    'L': 2,
                                  },
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
                                ListOfTags(tags: {
                                  'S': 0,
                                  'M': 1,
                                  'L': 2,
                                }),
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
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _swiperController.dispose();
  }
}

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
          BlocProvider.of<ProductDetailsCubit>(context)
              .emit(ProductDetailsSuccessState(index));

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
