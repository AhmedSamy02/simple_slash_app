import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:like_button/like_button.dart';
import 'package:numeral/numeral.dart';
import 'package:simple_slash_app/constants.dart';
import 'package:simple_slash_app/models/product.dart';
import 'package:simple_slash_app/services/get_all_products.dart';
import 'package:simple_slash_app/utils/check_mark_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _pageSize = 11;

  final PagingController<int, Product> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  bool loadingStart = false;
  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await GetAllProducts.getProducts(_pageSize, pageKey);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

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
        child: CustomRefreshIndicator(
          onRefresh: () {
            return Future(() async {
              _pagingController.refresh();
            });
          },
          builder: (context, child, controller) {
            return CheckMarkIndicator(child: child);
          },
          child: PagedGridView<int, Product>(
            pagingController: _pagingController,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 0.85, mainAxisSpacing: 20),
            builderDelegate: PagedChildBuilderDelegate(
              itemBuilder: (context, item, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, kProductDetailsScreen,arguments: item.id);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: ProductCardImage(
                            imageURL: item.image ??
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQYZkVHaCkd6Opc6l1aunktO2Y_ILQyPND4JwCnwWVP4w&s',
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12.0, left: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Text(
                                    '${item.name} - ${item.brand!.name}',
                                    maxLines: 2,
                                    style: GoogleFonts.roboto(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: CachedNetworkImage(
                                      imageUrl: item.brand!.logo!,
                                      imageBuilder: (context, imageProvider) {
                                        return CircleAvatar(
                                          backgroundImage: imageProvider,
                                          backgroundColor: Colors.black,
                                          radius: 20,
                                        );
                                      },
                                      progressIndicatorBuilder:
                                          (context, url, progress) {
                                        return const SpinKitFadingFour(
                                          color: Colors.white,
                                        );
                                      },
                                      errorListener: (value) {},
                                      errorWidget: (context, url, error) {
                                        return const CircleAvatar(
                                          backgroundColor: Colors.black,
                                          foregroundImage: AssetImage(
                                            kBrandLogo,
                                          ),
                                        );
                                      },
                                      width: 30,
                                      height: 30,
                                    ),
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
                                  'EGP ${item.price!.numeral()}',
                                  style: GoogleFonts.roboto(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              LikeButton(
                                size: 26,
                                likeBuilder: (bool isLiked) {
                                  //TODO: Implement the like logic
                                  return Icon(
                                    isLiked
                                        ? Icons.favorite
                                        : Icons.favorite_outline,
                                    color: isLiked ? Colors.red : Colors.white,
                                  );
                                },
                              ),
                              LikeButton(
                                size: 26,
                                likeBuilder: (bool isLiked) {
                                  //TODO: Implement the add to cart logic
                                  return Icon(
                                    Icons.shopping_cart,
                                    color:
                                        isLiked ? Colors.green : Colors.white,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              newPageProgressIndicatorBuilder: (context) {
                return const Center(
                  child: SpinKitFadingFour(
                    color: Colors.white,
                  ),
                );
              },
              firstPageProgressIndicatorBuilder: (context) {
                if (!loadingStart) {
                  loadingStart = true;
                  return const Center(
                    child: SpinKitFadingFour(
                      color: Colors.white,
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pagingController.dispose();
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: CachedNetworkImage(
        width: MediaQuery.of(context).size.width / 3,
        imageUrl: imageURL,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            const SpinKitFadingFour(
          color: Colors.white,
        ),
      ),
    );
  }
}
