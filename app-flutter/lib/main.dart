import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive/hive.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './src/pages/pages.dart';
import './src/constants/constants.dart';
import 'package:shilingi/src/models/hive.dart';
import './src/pages/new_purchase/data_models.dart';
import './firebase_options.dart';

const apiUrl = String.fromEnvironment('API_URL',
    defaultValue: 'http://localhost:8080/query');

void main() async {
  await initHiveForFlutter();
  Hive.registerAdapter(ShoppingListAdapter());
  Hive.registerAdapter(ShoppingListItemAdapter());
  Hive.registerAdapter(NewPurchaseModelAdapter());
  Hive.registerAdapter(ItemModelAdapter());

  final HttpLink httpLink = HttpLink(apiUrl);
  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(store: HiveStore()),
    ),
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  final ValueNotifier<GraphQLClient> client;

  const MyApp({Key? key, required this.client}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final userStream = FirebaseAuth.instance.userChanges();
    return StreamBuilder<User?>(
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return MaterialApp(
              title: 'Shillingi',
              theme: ThemeData(
                primarySwatch: Colors.lightGreen,
                textTheme: GoogleFonts.rubikTextTheme(),
                appBarTheme: AppBarTheme.of(context).copyWith(elevation: 0),
              ),
              home: const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          default:
            if (snapshot.hasError) {
              return MaterialApp(
                title: 'Shillingi',
                theme: ThemeData(
                  primarySwatch: Colors.lightGreen,
                  textTheme: GoogleFonts.rubikTextTheme(),
                  appBarTheme: AppBarTheme.of(context).copyWith(elevation: 0),
                ),
                home: Scaffold(
                  body: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(
                          FeatherIcons.alertOctagon,
                          color: Colors.redAccent,
                          size: 50.0,
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'An error occurred and we were unable to resolve it. Kindly exit and restart the application',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            // Check if user is logged in
            if (snapshot.data == null) {
              return MaterialApp(
                title: 'Shillingi',
                theme: ThemeData(
                  primarySwatch: Colors.lightGreen,
                  textTheme: GoogleFonts.rubikTextTheme(),
                  appBarTheme: AppBarTheme.of(context).copyWith(elevation: 0),
                ),
                home: const LoginPage(),
              );
            }

            return GraphQLProvider(
              client: client,
              child: MaterialApp(
                title: 'Shillingi',
                theme: ThemeData(
                  primarySwatch: Colors.lightGreen,
                  textTheme: GoogleFonts.rubikTextTheme(),
                  appBarTheme: AppBarTheme.of(context).copyWith(elevation: 0),
                ),
                themeMode: ThemeMode.dark,
                initialRoute: '/',
                routes: {
                  purchasesPage: (context) => const PurchasesPage(),
                  newPurchasePage: (context) => const NewPurchasePage2(),
                  PurchaseDetailsPage.routeName: (context) =>
                      const PurchaseDetailsPage(),
                  cataloguePage: (context) => const CataloguePage(),
                  shoppingItemPage: (context) => const ShoppingItemDetailPage(),
                  shoppingListPage: (context) => const ShoppingListPage(),
                  '/login': ((context) => const LoginPage()),
                },
              ),
            );
        }
      },
      stream: userStream,
    );
  }
}
