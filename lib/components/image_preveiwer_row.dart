import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:simple_slash_app/constants.dart';

class ImagesPreviewerRow extends StatefulWidget {
  const ImagesPreviewerRow({
    super.key,
    required this.swiperController,
    required this.images,
  });
  final SwiperController swiperController;
  final List<String> images;

  @override
  State<ImagesPreviewerRow> createState() => _ImagesPreviewerRowState();
}

class _ImagesPreviewerRowState extends State<ImagesPreviewerRow> {
  final _upperPageController = PageController(
    viewportFraction: 0.7,
    initialPage: 0,
  );
  final _lowerPageController = ScrollController();
  bool _initial = true;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.425,
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: PageView.builder(
              itemCount: widget.images.length,
              controller: _upperPageController,
              dragStartBehavior: DragStartBehavior.down,
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _upperPageController,
                  builder: (context, child) {
                    double pageOffset = 0;
                    if (_initial && index == 1) {
                      _initial = false;
                      pageOffset = -1;
                    }
                    if (_upperPageController.position.haveDimensions) {
                      pageOffset = _upperPageController.page! - index;
                    }
                    return Transform.rotate(
                      angle: -pageOffset * 0.4,
                      origin:
                          pageOffset > 0 ? Offset(100, 10) : Offset(-100, -10),
                      child: FullScreenWidget(
                        disposeLevel: DisposeLevel.Low,
                        child: Card(
                          color: Colors.white,
                          elevation: 24,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: CachedNetworkImage(
                              imageUrl: widget.images[index],
                              errorWidget: (context, url, error) {
                                return Image.asset(
                                  kBrandLogo,
                                  fit: BoxFit.fill,
                                );
                              },
                              progressIndicatorBuilder:
                                  (context, url, progress) {
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
                    );
                  },
                );
              },
            ),
          ),
          Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        _upperPageController.animateToPage(
                          index,
                          duration: Durations.extralong1,
                          curve: Easing.legacy,
                        );
                        // _lowerPageController.animateTo(
                        //   index.toDouble(),
                        //   duration: Durations.extralong1,
                        //   curve: Easing.legacy,
                        // );
                      },
                      child: AnimatedBuilder(
                        animation: _upperPageController,
                        builder: (context, child) {
                          double opacity = 0;
                          
                          if (_upperPageController.position.haveDimensions) {
                            opacity =
                                1 - (_upperPageController.page! - index).abs();
                          }
                          return Container(
                            margin: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: kDefaultActiveChipColor.withOpacity(
                                    opacity.clamp(0, 1).toDouble()),
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              clipBehavior: Clip.antiAlias,
                              child: CachedNetworkImage(
                                imageUrl: widget.images[index],
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
                          );
                        },
                      ),
                    );
                  },
                  itemCount: widget.images.length,
                  controller: _lowerPageController))
        ],
      ),
    );
  }
}
