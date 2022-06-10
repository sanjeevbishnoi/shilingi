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

var vendorsQuery = gql(r'''
    query vendors {
      vendors {
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

var itemsQueryWithLabels = gql(r'''
    query items($tagID: Int, $negate: Boolean) {
      items(tagID: $tagID, negate: $negate) {
        id
        name
        tags {
          id
          name
        }
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

var shoppingListQuery = gql(r'''
    query shoppingList($after: Cursor, $first: Int, $before: Cursor, $last: Int) {
      shoppingList(after: $after, first: $first, before: $before, last: $last) {
        totalCount
        pageInfo {
          hasNextPage
          hasPreviousPage
          startCursor
          endCursor
        }
        edges {
          cursor
          node {
            id
            name
            createTime
            updateTime
          }
        }
      }
    }
''');

var shoppingDetailQuery = gql(r'''
    query shoppingListDetail($id: Int!) {
      node(id: $id) {
        ... on ShoppingList {
          id
          name
          createTime
          updateTime
          items {
            id
            note
            item {
              id
              name
              purchases(first: 1) {
                edges {
                  node {
                    id
                    total
                    pricePerUnit
                    units
                    shopping {
                      id
                      date
                    }
                  }
                }
              }
              tags {
                id
                name
              }
            }
            purchase {
              id
              pricePerUnit
              units
              brand
              quantity
              quantityType
              total
              shopping {
                id
                date
              }
            }
          }
        }
      }
    }
''');

var savedNewPurchaseWithVendorQuery = gql(r'''
    query savedNewPurchaseWithVendor($vendorId: Int!, $itemIds: [Int!]!) {
      node(id: $vendorId)  {
        ... on Vendor {
          id
          name
        }
      }

      itemsByID(ids: $itemIds) {
        id
        name
        purchases(first: 1) {
          edges {
            node {
              id
              total
              pricePerUnit
              units
              shopping {
                id
                date
              }
            }
          }
        }
        tags {
          id
          name
        }
      }
    }
''');

var savedNewPurchaseQuery = gql(r'''
    query savedNewPurchaseWithVendor($itemIds: [Int!]!) {
      itemsByID(ids: $itemIds) {
        id
        name
        purchases(first: 1) {
          edges {
            node {
              id
              total
              pricePerUnit
              units
              shopping {
                id
                date
              }
            }
          }
        }
        tags {
          id
          name
        }
      }
    }
''');

var nodeItemQuery = gql(r'''
    query nodeItem($id: Int!) {
      node(id: $id) {
        ... on Item {
          id
          name
          purchases(first: 1) {
            edges {
              node {
                id
                total
                pricePerUnit
                units
                shopping {
                  id
                  date
                }
              }
            }
          }
          tags {
            id
            name
          }
        }
      }
    }
''');
