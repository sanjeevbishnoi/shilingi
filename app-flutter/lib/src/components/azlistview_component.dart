import 'package:flutter/material.dart';

import 'package:azlistview/azlistview.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

abstract class Nameable {
  final String name = '';
}

class AZItem<E extends Nameable> extends ISuspensionBean {
  final E item;
  final Widget child;

  AZItem({required this.item, required this.child});

  @override
  String getSuspensionTag() {
    return item.name[0].toUpperCase();
  }
}

typedef AZCallback = List<AZItem> Function();

class CustomAZListView<E extends Nameable> extends HookWidget {
  final List<Nameable> data;
  final List<Widget> children;
  final EdgeInsets? padding;
  final Object? hash;

  const CustomAZListView(
      {Key? key,
      required this.data,
      required this.children,
      this.padding,
      this.hash})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var azData = useState<List<AZItem>>([]);
    useEffect(() {
      List<AZItem> result = [];
      data.asMap().forEach((index, d) {
        result.add(AZItem(item: d, child: children[index]));
      });
      SuspensionUtil.sortListBySuspensionTag(result);
      azData.value = result;
      return;
    }, [data, hash]);

    return AzListView(
      padding: padding,
      data: azData.value,
      itemCount: children.length,
      itemBuilder: (context, index) => azData.value[index].child,
      indexBarOptions: const IndexBarOptions(
        indexHintAlignment: Alignment.centerRight,
        indexHintOffset: Offset(-40, 0),
      ),
      indexBarMargin: const EdgeInsets.only(left: 20.0),
    );
  }
}
