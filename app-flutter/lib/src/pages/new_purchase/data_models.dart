import 'package:flutter/material.dart';

import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:gql/ast.dart';

import '../../models/model.dart';
import '../../gql/gql.dart';

part 'data_models.g.dart';

const _uuid = Uuid();
const newPurchaseBoxName = "newpurchase";
// We can only save a single purchase entry at the moment
const defaultPurchaseId = "newpurchase";

class PurchaseItemModel extends ChangeNotifier {
  PurchaseItemModel({
    required this.itemId,
    int? units,
    double? pricePerUnit,
    double? quantity,
    String? quantityType,
    String? brand,
    this.uuid,
    this.item,
    bool isAmountPerItem = false,
  })  : _units = units,
        _pricePerUnit = pricePerUnit,
        _quantity = quantity,
        _quantityType = quantityType,
        _brand = brand,
        _isAmountPerItem = isAmountPerItem;

  factory PurchaseItemModel.fromItemModel(ItemModel model) {
    return PurchaseItemModel(
      itemId: model.itemId,
      units: model.units,
      pricePerUnit:
          model.isAmountPerItem ? model.amount : model.amount * model.units,
      quantity: model.quantity,
      quantityType: model.quantityType,
      brand: model.brand,
      uuid: model.uuid,
      item: model.item,
      isAmountPerItem: model.isAmountPerItem,
    );
  }

  final Item? item;
  final int itemId;
  final String? uuid;
  double? _pricePerUnit;
  int? _units = 1;
  double? _quantity;
  String? _quantityType;
  String? _brand;
  bool _isAmountPerItem;

  final Map<String, String> _errors = {};

  int? get units => _units;
  set units(int? units) {
    _units = units;
    notifyListeners();
  }

  double? get pricePerUnit => _pricePerUnit;
  set pricePerUnit(double? pricePerUnit) {
    _pricePerUnit = pricePerUnit;
    notifyListeners();
  }

  double? get quantity => _quantity;
  set quantity(double? quantity) {
    _quantity = quantity;
    notifyListeners();
  }

  String? get quantityType => _quantityType;
  set quantityType(String? quantityType) {
    _quantityType = quantityType;
    notifyListeners();
  }

  String? get brand => _brand;
  set brand(String? brand) {
    _brand = brand;
    notifyListeners();
  }

  bool get isAmountPerItem => _isAmountPerItem;
  set isAmountPerItem(bool isAmountPerItem) {
    _isAmountPerItem = isAmountPerItem;
    notifyListeners();
  }

  bool validate() {
    _errors.clear();
    if (_units == null) {
      _errors['units'] = 'This field is required';
    } else if (_units! < 1) {
      _errors['units'] = 'Units cannot be less than 1';
    }

    if (_pricePerUnit == null) {
      _errors['pricePerUnit'] = 'Amount is required';
    }

    notifyListeners();
    return _errors.isEmpty;
  }

  Map<String, String> get errors => _errors;

  ItemModel toItemModel() {
    if (uuid == null) {
      return ItemModel(
        uuid: _uuid.v1(),
        item: item,
        itemId: itemId,
        amount: _isAmountPerItem ? _pricePerUnit! : _pricePerUnit! / _units!,
        units: units!,
        quantity: _quantity,
        quantityType: _quantityType,
        brand: _brand,
        isAmountPerItem: _isAmountPerItem,
      );
    }
    return ItemModel(
      uuid: uuid!,
      item: item,
      itemId: itemId,
      amount: _isAmountPerItem ? _pricePerUnit! : _pricePerUnit! / _units!,
      units: units!,
      quantity: _quantity,
      quantityType: _quantityType,
      brand: _brand,
      isAmountPerItem: _isAmountPerItem,
    );
  }
}

@HiveType(typeId: 3)
class NewPurchaseModel extends ChangeNotifier {
  NewPurchaseModel(
      {Vendor? vendor, DateTime? date, List<ItemModel> items = const []})
      : _vendor = vendor,
        _date = date,
        _items = items,
        vendorId = vendor?.id;

  Vendor? _vendor;

  /// Stores the new purchase data
  Box<NewPurchaseModel>? _box;

  /// The following fields are saved in Hive
  @HiveField(0)
  DateTime? _date;

  @HiveField(1)
  List<ItemModel> _items;

  @HiveField(2)
  int? vendorId;

  String _searchString = '';

  static Future<NewPurchaseModel> maybeRestore(
      BuildContext context, Vendor? vendor, DateTime? date) async {
    // Open box
    final box = await Hive.openBox<NewPurchaseModel>(newPurchaseBoxName);
    var model = box.get(defaultPurchaseId) ??
        NewPurchaseModel(vendor: vendor, date: date);
    model.box = box;

    if (model.vendorId != null || model.items.isNotEmpty) {
      // We can fetch data for vendor and/or items
      DocumentNode document;
      Map<String, dynamic> variables;
      if (model.vendorId != null) {
        document = savedNewPurchaseWithVendorQuery;
        variables = {
          'vendorId': model.vendorId,
          'itemIds': [
            for (var item in model.items) item.itemId,
          ],
        };
      } else {
        document = savedNewPurchaseQuery;
        variables = {
          'itemIds': [
            for (var item in model.items) item.itemId,
          ],
        };
      }

      final cli = GraphQLProvider.of(context).value;
      var result = await cli.query(
        QueryOptions(
          document: document,
          variables: variables,
        ),
      );
      if (result.hasException) {
        model = NewPurchaseModel(vendor: vendor, date: date);
        const snackBar =
            SnackBar(content: Text('Unable to load your saved data'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        if (model.vendorId != null) {
          final vendor = Vendor.fromJson(result.data!['node']);
          model.vendor = vendor;
        }
        final d = {'items': result.data!['itemsByID']};
        final items = Items.fromJson(d);
        for (var item in items.items) {
          final index =
              model.items.indexWhere((model) => model.itemId == item.id);
          if (index != -1) {
            var m = model.items[index];
            var newM = ItemModel(
              itemId: m.itemId,
              amount: m.amount,
              units: m.units,
              uuid: m.uuid,
              item: item,
              isAmountPerItem: m.isAmountPerItem,
              quantity: m.quantity,
              quantityType: m.quantityType,
              brand: m.brand,
            );
            model.items[index] = newM;
          }
        }
      }
    }

    return model;
  }

  set box(Box<NewPurchaseModel> box) => _box = box;

  Future<Box<NewPurchaseModel>> _getBox() async {
    if (_box != null) {
      return _box!;
    }
    _box = await Hive.openBox<NewPurchaseModel>(newPurchaseBoxName);
    return _box!;
  }

  Vendor? get vendor => _vendor;
  set vendor(Vendor? vendor) {
    _vendor = vendor;
    vendorId = vendor!.id;
    persistToStorage();
    notifyListeners();
  }

  DateTime? get date => _date;
  set date(DateTime? date) {
    _date = date;
    persistToStorage();
    notifyListeners();
  }

  String get searchString => _searchString;
  set searchString(String searchString) {
    _searchString = searchString.trim();
    notifyListeners();
  }

  List<ItemModel> get items => _items;
  set items(List<ItemModel> items) {
    _items = items;
    persistToStorage();
    notifyListeners();
  }

  void addItem(BuildContext context, ItemModel item) {
    _items = [...items, item];
    persistToStorage();
    notifyListeners();
    _fetchItemDetails(context, item);
  }

  /// This method should query the API for more information on the item such as
  /// the last purchase done.
  /// We only need to query this information:
  ///   1. When the user has confirmed to add the item to the list of items
  ///   2. When retrieving purchase from the store
  void _fetchItemDetails(BuildContext context, ItemModel item) async {
    final cli = GraphQLProvider.of(context).value;
    final result = await cli.query(
      QueryOptions(document: nodeItemQuery, variables: {
        'id': item.itemId,
      }),
    );
    if (result.hasException) {
      return;
    }
    final i = Item.fromJson(result.data!['node']);
    item = ItemModel(
      uuid: item.uuid,
      item: i,
      itemId: i.id!,
      amount: item.amount,
      units: item.units,
      quantity: item.quantity,
      quantityType: item.quantityType,
      brand: item.brand,
      isAmountPerItem: item.isAmountPerItem,
    );
    updateItem(item);
  }

  /// We could optionally use an index but that would mean we pass the index
  /// to the child widget that is responsible for displaying a modal in the base
  /// new page list view
  /// We will just stick to using uuid here to indentify what needs to be replaced
  void updateItem(ItemModel item) {
    final index = _items.indexWhere((i) => item.uuid == i.uuid);
    if (index != -1) {
      _items[index] = item;
      persistToStorage();
      notifyListeners();
    }
  }

  void removeItem(int index) {
    _items = [...items.sublist(0, index), ...items.sublist(index + 1)];
    persistToStorage();
    notifyListeners();
  }

  void removeItemByUUID(String uuid) {
    final i = _items.indexWhere((model) => model.uuid == uuid);
    if (i != -1) {
      _items = [..._items.sublist(0, i), ..._items.sublist(i + 1)];
      notifyListeners();
    }
  }

  List<ItemModel> get filteredItems {
    if (_searchString.isEmpty) return _items;
    return _items
        .where((model) =>
            model.item?.name
                .toLowerCase()
                .contains(_searchString.toLowerCase()) ??
            false)
        .toList();
  }

  double get total {
    var total = 0.0;
    _items.forEach((item) {
      total += item.total;
    });
    return total;
  }

  void persistToStorage() async {
    final box = await _getBox();
    box.put(defaultPurchaseId, this);
  }

  bool get isValid {
    return _items.isNotEmpty && vendorId != null;
  }

  bool get canDelete {
    return vendorId != null || _items.isNotEmpty;
  }

  Json toJson() {
    return {
      'date': DateTimeToJson(_date!),
      'vendor': {
        'id': vendorId,
      },
      'items': [
        for (var item in _items)
          {
            'units': item.units,
            'pricePerUnit': item.amount,
            'item': item.itemId,
            if (item.quantity != null) 'quantity': item.quantity,
            if (item.quantityType != null) 'quantityType': item.quantityType,
            if (item.brand != null) 'brand': item.brand,
          },
      ],
    };
  }

  void clear() async {
    final box = await _getBox();
    box.delete(defaultPurchaseId);
    _vendor = null;
    vendorId = null;
    _date = DateTime.now();
    _items = [];
    notifyListeners();
  }

  static Future<bool> hasStoredPurchase() async {
    final box = await Hive.openBox<NewPurchaseModel>(newPurchaseBoxName);
    return box.get(defaultPurchaseId) != null;
  }
}

@HiveType(typeId: 4)
class ItemModel {
  const ItemModel({
    required this.itemId,
    required this.amount,
    required this.units,
    required this.uuid,
    this.isAmountPerItem = false,
    this.quantity,
    this.quantityType,
    this.brand,
    this.item,
  });

  @HiveField(0)
  final String uuid;
  final Item? item;
  @HiveField(1)
  final int itemId;
  @HiveField(2)
  final double amount;
  @HiveField(3)
  final int units;
  @HiveField(4)
  final double? quantity;
  @HiveField(5)
  final String? quantityType;
  @HiveField(6)
  final String? brand;
  @HiveField(7)
  final bool isAmountPerItem;

  double get total => units * amount;
}
