import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DescriptionBar extends StatelessWidget {
  const DescriptionBar({
    super.key,
    required this.text,
  });
  final String text;
  @override
  Widget build(BuildContext context) {
    return Accordion(
      disableScrolling: true,
      scaleWhenAnimating: false,
      children: [
        AccordionSection(
          header: Text(
            'Description',
            style: GoogleFonts.roboto(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
          ),
          headerPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          content: Text(
            text,
            style: GoogleFonts.roboto(
              fontSize: 15.0,
              color: Colors.white,
            ),
          ),
          headerBorderWidth: 0,
          headerBackgroundColor: Colors.grey[850],
          contentBackgroundColor: Colors.grey[850],
          contentBorderWidth: 0,
          contentBorderRadius: 10,
        ),
      ],
    );
  }
}
