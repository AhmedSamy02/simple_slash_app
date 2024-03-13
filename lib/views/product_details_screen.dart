import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:chip_list/chip_list.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_slash_app/constants.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Swiper(
              layout: SwiperLayout.CUSTOM,
              customLayoutOption:
                  CustomLayoutOption(startIndex: -1, stateCount: 3)
                    ..addRotate(
                      [-45.0 / 180, 0.0, 45.0 / 180],
                    )
                    ..addTranslate([
                      Offset(-300.0, -40.0),
                      Offset(.0, 0.0),
                      Offset(300.0, -40.0)
                    ]),
              itemWidth: 300.0,
              itemHeight: 250.0,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.blueAccent,
                  elevation: 10,
                );
              },
              pagination: SwiperCustomPagination(
                builder: (context, config) {
                  return Container();
                },
              ),
              itemCount: 10,
              loop: false,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 18,
                bottom: 2,
              ),
              child: SizedBox(
                height: 75,
                child: ImageSliderChooser(),
              ),
            ),
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
                            'Product Name',
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
                          'EGP 1000',
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
                      CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                          'https://picsum.photos/200/300',
                        ),
                        radius: 26,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: SizedBox(
                          width: 120,
                          child: Text(
                            'Brand Name',
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
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SelectTextHeader(head: 'Color'),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ColorHorizontalList(
                    position: 0,
                    colors: [
                      Colors.red,
                      Colors.blue,
                      Colors.green,
                      Colors.yellow,
                      Colors.purple,
                      Colors.orange,
                      Colors.pink,
                      Colors.teal,
                      Colors.brown,
                      Colors.grey,
                      Colors.indigo,
                      Colors.lime,
                      Colors.amber,
                      Colors.cyan,
                      Colors.deepPurple,
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SelectTextHeader(head: 'Size'),
                  ListOfTags(tags: ['S', 'M', 'L', 'XL']),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SelectTextHeader(head: 'Material'),
                  ListOfTags(tags: ['Cotton', 'Polyester', 'Wool', 'Silk']),
                ],
              ),
            ),
          ],
        ),
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
    // TODO: implement initState
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
          size: Size.fromRadius(11),
          activeSize: Size.fromRadius(12),
          spacing: EdgeInsets.all(5),
          activeColors: widget.colors,
          colors: widget.colors,
          shape: CircleBorder(
            side: BorderSide(
              color: Colors.white12,
              width: 2,
              strokeAlign: 1,
            ),
          ),
          activeShape: CircleBorder(
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

class ListOfTags extends StatelessWidget {
  const ListOfTags({
    super.key,
    required this.tags,
  });
  final List<String> tags;
  @override
  Widget build(BuildContext context) {
    return ChipList(
      listOfChipNames: tags,
      showCheckmark: false,
      shouldWrap: true,
      listOfChipIndicesCurrentlySeclected: [0],
      inactiveBorderColorList: [Colors.transparent],
      activeBgColorList: [kDefaultActiveChipColor],
      activeTextColorList: [Colors.black],
      style: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      inactiveBgColorList: [Colors.grey[900]!],
      borderRadiiList: [10],
      activeBorderColorList: [kDefaultActiveChipColor],
      inactiveTextColorList: [Colors.white],
    );
  }
}

class SelectTextHeader extends StatelessWidget {
  const SelectTextHeader({
    super.key,
    required this.head,
  });
  final String head;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        'Select $head',
        style: GoogleFonts.roboto(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

class ImageSliderChooser extends StatelessWidget {
  const ImageSliderChooser({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 4,
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: kDefaultActiveChipColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                'https://picsum.photos/200/300',
                fit: BoxFit.cover,
                width: 45,
              ),
            ),
          ),
        );
      },
    );
  }
}
