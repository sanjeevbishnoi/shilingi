import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/model.dart';
import './text.dart';
import '../pages/pages.dart';

var f = NumberFormat('#,##0.00', 'en_US');

class WPurchase extends StatelessWidget {
  final Purchase purchase;

  const WPurchase(this.purchase, [Key? key]) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8.0),
          splashColor: Colors.black12,
          onTap: () {
            Navigator.of(context).pushNamed(PurchaseDetailsPage.routeName,
                arguments:
                    PurchaseDetailsRouteSettings(purchaseId: purchase.id!));
          },
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 18.0, horizontal: 18.0),
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
                              purchase.vendor!.name,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text('Kes ${f.format(purchase.total)}',
                              style: GoogleFonts.rubik().copyWith(
                                  fontSize: 16.0, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                          DateFormat("EEE, MMM d, ''yy'")
                              .format(purchase.date.toLocal()),
                          style: const TextStyle(color: Color(0XFF6a6a6a))),
                    ],
                  ),
                ),
                const SizedBox(width: 5.0),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
