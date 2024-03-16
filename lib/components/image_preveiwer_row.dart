import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:simple_slash_app/constants.dart';

class ImagesPreviewerRow extends StatelessWidget {
  const ImagesPreviewerRow({
    super.key,
    required this.swiperController,
    required this.images,
  });

  final SwiperController swiperController;
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return Swiper(
      controller: swiperController,
      outer: false,
      layout: SwiperLayout.CUSTOM,
      containerHeight: MediaQuery.of(context).size.height * 0.3,
      customLayoutOption: CustomLayoutOption(startIndex: -1, stateCount: 3)
        ..addRotate(
          [-60.0 / 180, 0.0, 60.0 / 180],
        )
        ..addScale([0.9, 1, 1], Alignment.centerLeft)
        ..addOpacity([0.5, 1, 1])
        ..addTranslate([
          const Offset(-280.0, -50.0),
          const Offset(0.0, 0.0),
          const Offset(270.0, -60.0)
        ]),
      itemWidth: MediaQuery.of(context).size.width * 0.7,
      itemHeight: MediaQuery.of(context).size.height * 0.315,
      itemBuilder: (context, index) {
        return SafeArea(
          child: FullScreenWidget(
            disposeLevel: DisposeLevel.Low,
            child: Hero(
              tag: 'smallImage',
              child: Card(
                color: Colors.white,
                elevation: 18,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: images[index],
                    errorWidget: (context, url, error) {
                      return Image.asset(
                        kBrandLogo,
                        fit: BoxFit.fill,
                      );
                    },
                    progressIndicatorBuilder: (context, url, progress) {
                      return const Center(
                        child: SpinKitFadingCube(
                          color: Colors.white,
                          size: 20,
                        ),
                      );
                    },
                    filterQuality: FilterQuality.none,
                  ),
                ),
              ),
            ),
          ),
        );
      },
      pagination: SwiperCustomPagination(
        builder: (context, config) {
          return Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.31,
              ),
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.1,
                child: Center(
                  child: ListView.builder(
                    itemCount: images.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          swiperController.move(index);
                        },
                        child: Container(
                          margin: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: config.activeIndex != index
                                  ? Colors.transparent
                                  : kDefaultActiveChipColor,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            clipBehavior: Clip.antiAlias,
                            child: CachedNetworkImage(
                              imageUrl: images[index],
                              errorWidget: (context, url, error) {
                                return Image.asset(
                                  kBrandLogo,
                                  fit: BoxFit.fill,
                                );
                              },
                              progressIndicatorBuilder:
                                  (context, url, progress) {
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
                  ),
                ),
              ),
            ],
          );
        },
      ),
      curve: Curves.linear,
      itemCount: images.length,
      loop: false,
    );
  }
}
