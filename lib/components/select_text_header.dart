import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
