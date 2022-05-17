import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'hive.g.dart';

const boxName = "shopping_list";

@HiveType(typeId: 1)
class ShoppingList extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  List<ShoppingListItem> items;

  Box<ShoppingList>? listBox;

  ShoppingList({required this.id, this.items = const []});

  void addItem(ShoppingListItem item) {
    var index = items.indexWhere((element) => element.id == item.id);
    if (index != -1) {
      items[index] = item;
    } else {
      items = [...items, item];
    }
    saveList();
  }

  void removeItem(int id) {
    final index = items.indexWhere((element) => element.id == id);
    if (index != -1) {
      final newItems = List.from(items);
      newItems.removeAt(index);
      items = [...newItems];
      saveList();
      print('removeItem');
    }
  }

  ShoppingListItem? getItem(int id) {
    var index = items.indexWhere((element) => element.id == id);
    if (index == -1) {
      return null;
    }
    return items[index];
  }

  void saveList() async {
    listBox ??= await ShoppingList.getBox();

    // items = _items;
    listBox!.put(id.toString(), this);
  }

  void clear() async {
    listBox ??= await ShoppingList.getBox();
    listBox!.delete(id);
  }

  static Future<ShoppingList> getList(int id) async {
    final listBox = await ShoppingList.getBox();
    final list = listBox.get(id.toString());
    // if (list != null) {
    // list._items.addAll(list.items);
    // }

    return list ?? ShoppingList(id: id);
  }

  static Future<Box<ShoppingList>> getBox() async {
    return await Hive.openBox(boxName);
  }
}

typedef Json = Map<String, dynamic>;

@JsonSerializable()
@HiveType(typeId: 2)
class ShoppingListItem {
  @HiveField(0)
  int id;

  @HiveField(1)
  int units;

  @HiveField(2)
  int pricePerUnit;

  @HiveField(3)
  double? quantity;

  @HiveField(4)
  String? quantityType;

  @HiveField(5)
  String? brand;

  ShoppingListItem(
      {required this.id,
      required this.pricePerUnit,
      this.units = 1,
      this.quantity,
      this.quantityType,
      this.brand});

  factory ShoppingListItem.fromJson(Json json) =>
      _$ShoppingListItemFromJson(json);

  Json toJson() => _$ShoppingListItemToJson(this);
}
