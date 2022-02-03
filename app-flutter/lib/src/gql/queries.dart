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

var purchaseQuery = gql(r'''
    query purchase($id: Int!) {
      node(id: $id) {
        ... on Shopping {
          id
          date
          vendor {
            name
          }
          total
          items {
            id
            item {
                id
                name
            }
            pricePerUnit
            units
          }
        }
      }
    }
 ''');
