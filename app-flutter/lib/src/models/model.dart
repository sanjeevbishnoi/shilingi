class PurchaseItem {
  final double quantity;
  final String quantityType;
  final int units;
  final String? brand;
  final double pricePerUnit;
  final Item item;

  const PurchaseItem(
      {required this.quantity,
      required this.quantityType,
      required this.units,
      this.brand,
      required this.pricePerUnit,
      required this.item});

  double get total => units * pricePerUnit;
}

class Item {
  final String name;

  const Item({required this.name});
}

class Purchase {
  final DateTime date;
  final String market;
  final List<PurchaseItem> items;

  const Purchase(
      {required this.date, required this.market, required this.items});
}
