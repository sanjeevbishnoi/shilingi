import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/model.dart';
import './text.dart';

class WPurchase extends StatelessWidget {
  final Purchase purchase;

  const WPurchase(this.purchase, [Key? key]) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: const Color(0XFFF3F3F3),
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ListTitleText(
                            purchase.market,
                          ),
                        ),
                        Text('Kes 2,000',
                            style: GoogleFonts.rubik().copyWith(
                                fontSize: 16.0, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Text(DateFormat("EEE, MMM d, ''yy'").format(purchase.date),
                        style: const TextStyle(color: Color(0XFF6a6a6a))),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
