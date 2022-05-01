import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import './src/pages/pages.dart';
import './src/constants/constants.dart';

const apiUrl = String.fromEnvironment('API_URL',
    defaultValue: 'http://localhost:8080/query');

void main() async {
  await initHiveForFlutter();

  final HttpLink httpLink = HttpLink(apiUrl);
  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(store: HiveStore()),
    ),
  );

  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  final ValueNotifier<GraphQLClient> client;

  const MyApp({Key? key, required this.client}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        title: 'Shilingi',
        theme: ThemeData(
          primarySwatch: Colors.lightGreen,
          textTheme: GoogleFonts.rubikTextTheme(),
          appBarTheme: AppBarTheme.of(context).copyWith(elevation: 0),
        ),
        themeMode: ThemeMode.dark,
        initialRoute: '/',
        routes: {
          purchasesPage: (context) => const PurchasesPage(),
          newPurchasePage: (context) => const NewPurchasePage(),
          PurchaseDetailsPage.routeName: (context) =>
              const PurchaseDetailsPage(),
          cataloguePage: (context) => const CataloguePage(),
          shoppingItemPage: (context) => const ShoppingItemDetailPage(),
          shoppingListPage: (context) => const ShoppingListPage(),
        },
      ),
    );
  }
}
