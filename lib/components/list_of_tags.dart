import 'package:chip_list/chip_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_slash_app/constants.dart';
import 'package:simple_slash_app/cubits/add_to_cart_cubit/add_to_cart_cubit.dart';
import 'package:simple_slash_app/cubits/add_to_cart_cubit/add_to_cart_states.dart';
import 'package:simple_slash_app/cubits/update_price_details_cubit/update_price_details_cubit.dart';
import 'package:simple_slash_app/cubits/update_price_details_cubit/update_price_details_states.dart';

class ListOfTags extends StatefulWidget {
  const ListOfTags({
    super.key,
    required this.tags,
  });
  final Map<String, int> tags;
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
        int id = widget.tags.values.elementAt(index);

        BlocProvider.of<UpdatePriceDetailsCubit>(context)
            .emit(UpdatePriceDetailsSuccessState(id: id));
        setState(() {
          _index = index;
        });
      },
      listOfChipNames: widget.tags.keys.toList(),
      showCheckmark: false,
      shouldWrap: true,
      listOfChipIndicesCurrentlySeclected: [_index],
      inactiveBorderColorList: [Colors.transparent],
      activeBgColorList: [kDefaultActiveChipColor],
      activeTextColorList: [Colors.black],
      style: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
      inactiveBgColorList: [Colors.grey[900]!],
      borderRadiiList: [10],
      activeBorderColorList: [kDefaultActiveChipColor],
      inactiveTextColorList: [Colors.white],
    );
  }
}
