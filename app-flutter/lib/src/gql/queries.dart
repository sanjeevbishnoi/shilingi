import 'package:graphql_flutter/graphql_flutter.dart';

var purchasesQuery = gql(r'''
    query purchases {
      purchases {
        id
        date
        vendor {
          name
        }
        total
      }
    }
''');
