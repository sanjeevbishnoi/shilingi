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

var mutationTagItems = gql(r'''
    mutation tagItems($itemIDs: [Int!]!, $tagID: Int!) {
      tagItems(itemIDs: $itemIDs, tagID: $tagID)
    }
''');

var mutationUntagItems = gql(r'''
    mutation untagItems($itemIDs: [Int!]!, $tagID: Int!) {
      untagItems(itemIDs: $itemIDs, tagID: $tagID) {
        id
        name
      }
    }
''');

var mutationEditTag = gql(r'''
    mutation editTag($id: Int!, $input: TagInput!) {
      editTag(id: $id, input: $input) {
        id
        name
      }
    }
''');

var mutationDeleteTag = gql(r'''
    mutation deleteTag($id: Int!) {
      deleteTag(id: $id)
    }
''');
