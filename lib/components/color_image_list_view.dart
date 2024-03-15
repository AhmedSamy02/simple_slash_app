import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:simple_slash_app/constants.dart';
import 'package:simple_slash_app/cubits/product_details/product_details_cubit.dart';
import 'package:simple_slash_app/cubits/product_details/product_details_states.dart';

class ColorImageListView extends StatefulWidget {
  const ColorImageListView({
    super.key,
    required this.images,
  });

  final Map<String, int> images;
  @override
  State<ColorImageListView> createState() => _ColorImageListViewState();
}

class _ColorImageListViewState extends State<ColorImageListView> {
  int _activeIndex = 0;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.images.length,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            BlocProvider.of<ProductDetailsCubit>(context).emit(
                ProductDetailsSuccessState(
                    widget.images.values.elementAt(index)));
            setState(() {
              _activeIndex = index;
            });
          },
          child: Container(
            margin: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              border: Border.all(
                color: _activeIndex != index
                    ? Colors.transparent
                    : kDefaultActiveChipColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              clipBehavior: Clip.antiAlias,
              child: CachedNetworkImage(
                imageUrl: widget.images.keys.elementAt(index),
                errorWidget: (context, url, error) {
                  return Image.asset(
                    kBrandLogo,
                    fit: BoxFit.fill,
                  );
                },
                progressIndicatorBuilder: (context, url, progress) {
                  return const Center(
                    child: SpinKitFadingCircle(
                      color: Colors.white70,
                      size: 20,
                    ),
                  );
                },
                fit: BoxFit.fill,
                width: 45,
              ),
            ),
          ),
        );
      },
    );
  }
}
