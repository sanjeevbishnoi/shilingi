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

var purchasesExpandedQuery = gql(r'''
    query purchases($after: Time!, $before: Time!) {
      purchases(after: $after, before: $before) {
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
              tags {
                id
                name
              }
          }
          pricePerUnit
          units
        }
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

var itemsQuery = gql(r'''
    query items($tagID: Int) {
      items(tagID: $tagID) {
        id
        name
      }
    }
''');

var shoppingItemsQuery = gql(r'''
    query shoppingItems($after: Time!, $before: Time!, $itemID: Int!) {
      shoppingItems(after: $after, before: $before, itemID: $itemID) {
        id
        pricePerUnit
        units
        item {
          id
          name
        }
        shopping {
          id
          date
          total
          vendor {
            id
            name
          }
        }
      }
    }
''');

var labelsQuery = gql(r'''
    query labels {
      tags {
        id
        name
      }
    }
''');
