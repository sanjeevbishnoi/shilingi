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
    query items($tagID: Int, $negate: Boolean) {
      items(tagID: $tagID, negate: $negate) {
        id
        name
      }
    }
''');

var labelItems = gql(r'''
    query itemsUnderSubLabel($labelID: Int!) {
      node(id: $labelID) {
        ... on Tag {
          id
          name
          children {
            id
            name
            items {
              id
              name
            }
          }
        }
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

var purchaseItemsByLabelQuery = gql(r'''
    query purchaseItemsByLabel ($after: Time!, $before: Time!, $tagID: Int!) {
      shoppingItemsByTag(after: $after, before: $before, tagID: $tagID) {
        id
        item {
          id
          name
        }
        pricePerUnit
        units
        total
      }
    }
''');

var unlabeledPurchaseItemsQuery = gql(r'''
    query unlabeledPurchaseItems ($after: Time!, $before: Time!) {
      untaggedShoppingItems(after: $after, before: $before) {
        id
        item {
          id
          name
        }
        pricePerUnit
        units
        total
      }
    }
''');
