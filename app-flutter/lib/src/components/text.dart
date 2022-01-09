import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class ListTitleText extends StatelessWidget {
  final String text;

  const ListTitleText(this.text, [Key? key]) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.rubik()
          .copyWith(fontWeight: FontWeight.w700, fontSize: 18.0),
    );
  }
}
