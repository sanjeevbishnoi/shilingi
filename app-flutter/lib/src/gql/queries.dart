import 'package:graphql_flutter/graphql_flutter.dart';

var purchasesQuery = gql(r'''
    query purchases($after: Time!, $before: Time!) {
      purchases(after: $after, before: $before) {
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

var vendorAndItemsNames = gql(r'''
    query vendorItemsList {
      vendors {
        id
        name
      }

      items {
        id
        name
      }
    }
''');
