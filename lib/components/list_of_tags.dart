import 'package:chip_list/chip_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_slash_app/constants.dart';

class ListOfTags extends StatefulWidget {
  const ListOfTags({
    super.key,
    required this.tags,
  });
  final List<String> tags;

  @override
  State<ListOfTags> createState() => _ListOfTagsState();
}

class _ListOfTagsState extends State<ListOfTags> {
  int _index = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChipList(
      extraOnToggle: (index) {
        setState(() {
          _index = index;
        });
      },
      listOfChipNames: widget.tags,
      showCheckmark: false,
      
      shouldWrap: true,
      listOfChipIndicesCurrentlySeclected: [_index],
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
