import 'package:hive/hive.dart';

const boxName = "shopping_list";

@HiveType(typeId: 1)
class ShoppingList extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  List<ShoppingListItem> items;

  Box? listBox;

  ShoppingList({required this.id, this.items = const []});

  void addItem(ShoppingListItem item) {
    var index = items.indexWhere((element) => element.id == item.id);
    if (index != -1) {
      items[index] = item;
    } else {
      items.add(item);
    }
    saveList();
  }

  void saveList() async {
    listBox ??= await ShoppingList.getBox();
    listBox!.put(id, this);
  }

  void clear() async {
    listBox ??= await ShoppingList.getBox();
    listBox!.delete(id);
  }

  static Future<ShoppingList?> getList(int id) async {
    final listBox = await ShoppingList.getBox();
    return listBox.get(id);
  }

  static Future<Box> getBox() async {
    return await Hive.openBox(boxName);
  }
}

class ShoppingListItem {
  int id;
  int units;
  int pricePerUnit;
  int? quantity;
  String? quantityType;
  String? brand;

  ShoppingListItem(
      {required this.id,
      required this.pricePerUnit,
      this.units = 1,
      this.quantity,
      this.quantityType,
      this.brand});
}
