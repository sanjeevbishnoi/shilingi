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

var mutationEditItem = gql(r'''
    mutation editItem($id: Int!, $input: ItemInput!) {
      editItem(id: $id, input: $input) {
        id
        name
      }
    }
''');

var mutationCreateSubLabel = gql(r'''
    mutation createSubLabel($tagID: Int!, $input: SubLabelInput!) {
      createSubLabel(tagID: $tagID, input: $input) {
        id
        name
      }
    }
''');

var mutationAddItemsToSubLabel = gql(r'''
    mutation addItemsToSubLabel($subLabelID: Int!, $itemIDs: [Int!]!) {
      addItemsToSubLabel(subLabelID: $subLabelID, itemIDs: $itemIDs) {
        id
        name
      }
    }
''');

var mutationDeleteSubLabel = gql(r'''
    mutation deleteSubLabel($subLabelID: Int!) {
      deleteSubLabel(subLabelID: $subLabelID)
    }
''');

var mutationRemoveItemsFromSubLabel = gql(r'''
    mutation removeItemsFromSubLabel($subLabelID: Int!, $itemIDs: [Int!]!) {
      removeItemsFromSubLabel(subLabelID: $subLabelID, itemIDs: $itemIDs) {
        id
        name
      }
    }
''');

var mutationEditSubLabel = gql(r'''
    mutation editSubLabel($subLabelID: Int!, $input: SubLabelInput!) {
      editSubLabel(subLabelID: $subLabelID, input: $input) {
        id
        name
      }
    }
''');

var mutationCreateItem = gql(r'''
    mutation createItem($input: ItemInput!) {
      createItem(input: $input) {
        id
        name
      }
    }
''');

var mutationCreateShoppingList = gql(r'''
    mutation createShoppingList($input: ShoppingListInput!) {
      createShoppingList(input: $input) {
        id
        name
      }
    }
''');

var mutationDeleteShoppingList = gql(r'''
    mutation deleteShoppingList($id: Int!) {
      deleteShoppingList(id: $id)
    }
''');
