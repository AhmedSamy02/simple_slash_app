import 'package:analyzer_plugin/utilities/pair.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_slash_app/components/brand_details.dart';
import 'package:simple_slash_app/components/color_horizontal_list.dart';
import 'package:simple_slash_app/components/color_image_list_view.dart';
import 'package:simple_slash_app/components/description_bar.dart';
import 'package:simple_slash_app/components/image_preveiwer_row.dart';
import 'package:simple_slash_app/components/list_of_tags.dart';
import 'package:simple_slash_app/components/product_name_widget.dart';
import 'package:simple_slash_app/components/select_text_header.dart';
import 'package:simple_slash_app/constants.dart';
import 'package:simple_slash_app/cubits/add_to_cart_cubit/add_to_cart_cubit.dart';
import 'package:simple_slash_app/cubits/add_to_cart_cubit/add_to_cart_states.dart';
import 'package:simple_slash_app/cubits/product_details/product_details_cubit.dart';
import 'package:simple_slash_app/cubits/product_details/product_details_states.dart';
import 'package:simple_slash_app/cubits/update_details_cubit/update_details_cubit.dart';
import 'package:simple_slash_app/cubits/update_details_cubit/update_details_states.dart';
import 'package:simple_slash_app/cubits/update_price_details_cubit/update_price_details_cubit.dart';
import 'package:simple_slash_app/cubits/update_price_details_cubit/update_price_details_states.dart';
import 'package:simple_slash_app/models/product.dart';
import 'package:simple_slash_app/models/product_variation.dart';
import 'package:simple_slash_app/services/get_product_by_id.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _id = 0;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _id = ModalRoute.of(context)!.settings.arguments as int;
  }

  ProductVariation? _currentVariation;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProductDetailsCubit(),
        ),
        BlocProvider(
          create: (context) => UpdatePriceDetailsCubit(),
        ),
        BlocProvider(
          create: (context) => UpdateDetailsCubit(),
        ),
        BlocProvider(create: (context) => AddToCartCubit()),
      ],
      child: Scaffold(
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
                    BlocBuilder<ProductDetailsCubit, ProductDetailsStates>(
                      builder: (context, state) {
                        if (state is ProductDetailsInitialState) {
                          _currentVariation = product.variations![0];
                          return ImagesPreviewerRow(
                              images: _currentVariation!.images!);
                        } else if (state is ProductDetailsSuccessState) {
                          for (var variation in product.variations!) {
                            if (variation.id == state.id) {
                              _currentVariation = variation;
                              return ImagesPreviewerRow(
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ProductNameWidget(productName: product.name!),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: BlocBuilder<UpdatePriceDetailsCubit,
                                    UpdatePriceDetailsState>(
                                  builder: (context, state) {
                                    if (state
                                        is UpdatePriceDetailsInitialState) {
                                      return Text(
                                        'EGP ${product.variations![0].price}',
                                        style: GoogleFonts.roboto(
                                          fontSize: 17.0,
                                          color: Colors.white,
                                        ),
                                      );
                                    } else if (state
                                        is UpdatePriceDetailsSuccessState) {
                                      for (var variation
                                          in product.variations!) {
                                        if (variation.id == state.id) {
                                          _currentVariation = variation;
                                          BlocProvider.of<AddToCartCubit>(
                                                  context)
                                              .emit(AddToCartSuccess());
                                          logger.i(
                                              'Current Variation: ${_currentVariation!.id}');
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
                          ),
                          const Spacer(),
                          BrandDetails(product: product),
                        ],
                      ),
                    ),
                    BlocBuilder<UpdateDetailsCubit, UpdateDetailsState>(
                      builder: (context, state) {
                        List<int> variationIds = [];
                        if (product.colors == null) {
                          variationIds = product.getAllVariationIds();
                        } else {
                          variationIds = product.colors!.values.first;
                        }
                        late Pair<List<String>, List<String>> proprty;
                        if (state is UpdateDetailsInitialState) {
                          proprty = product.getSizesAndMaterialFromColor(
                              product.colors?.keys.first);
                        } else if (state is UpdateDetailsSuccessState) {
                          proprty =
                              product.getSizesAndMaterialFromColor(state.color);
                          variationIds = product.colors![state.color]!;
                        }
                        return Column(
                          children: [
                            product.colorImages == null
                                ? const SizedBox()
                                : Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: SelectTextHeader(head: 'Color'),
                                      ),
                                      ColorImageListView(
                                          images: product.colorImages!
                                              .map((key, value) {
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
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: ColorHorizontalList(
                                          position: 0,
                                          colors: product.colors!,
                                        ),
                                      )
                                    ],
                                  ),
                            proprty.first.isEmpty
                                ? const SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        const SelectTextHeader(head: 'Size'),
                                        ListOfTags(
                                          tags: Map.fromIterables(
                                              proprty.first, variationIds),
                                        ),
                                      ],
                                    ),
                                  ),
                            proprty.last.isEmpty
                                ? const SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        const SelectTextHeader(
                                            head: 'Material'),
                                        ListOfTags(
                                          tags: Map.fromIterables(
                                              proprty.last, variationIds),
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        );
                      },
                    ),
                    product.description == null || product.description == ''
                        ? const SizedBox()
                        : DescriptionBar(
                            text: product.description!,
                          ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: BlocBuilder<AddToCartCubit, AddToCartState>(
                        builder: (context, state) {
                          return GlowButton(
                            width: MediaQuery.of(context).size.width - 30,
                            height: 45,
                            disableColor: kDisabledColor,
                            onPressed: _currentVariation!.inStock!
                                ? () {
                                    final snackBar = SnackBar(
                                      elevation: 0,
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.transparent,
                                      content: AwesomeSnackbarContent(
                                        title: 'Success!',
                                        message:
                                            'Product Added To Cart Successfully!\nProduct Variation Id = ${_currentVariation!.id}',
                                        contentType: ContentType.success,
                                      ),
                                    );

                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentMaterialBanner()
                                      ..showSnackBar(snackBar);
                                  }
                                : null,
                            color: kDefaultActiveChipColor,
                            child: Text(
                              _currentVariation!.inStock!
                                  ? 'Add To Cart'
                                  : 'Out Of Stock',
                              style: GoogleFonts.roboto(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
