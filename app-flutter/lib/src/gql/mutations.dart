import 'package:graphql_flutter/graphql_flutter.dart';

var mutationCreatePurchase = gql(r'''
    mutation createPurchase($input: ShoppingInput!) {
      createPurchase(input: $input) {
        id
        date
        vendor {
          name
        }
        total
        items {
          id
          quantity
          quantityType
          units
          brand
          pricePerUnit
          item {
            name
          }
        }
      }
    }
''');

var mutationCreateLabel = gql(r'''
    mutation createLabel($input: TagInput!) {
      createTag(input: $input) {
        id
        name
      }
    }
''');
