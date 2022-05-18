import "package:flutter/material.dart";

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ms_undraw/ms_undraw.dart';

import '../gql/gql.dart';
import '../models/model.dart';
import '../constants/constants.dart';

class SelectVendorPage extends HookWidget {
  final String title;

  const SelectVendorPage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final queryResult = useQuery(QueryOptions(document: vendorsQuery));
    final result = queryResult.result;

    Widget body;

    if (result.isLoading && result.data == null) {
      body = const Center(
        child: CircularProgressIndicator(),
      );
    } else if (result.hasException) {
      body = Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UnDraw(
                illustration: UnDrawIllustration.warning,
                color: Colors.redAccent,
                height: 150,
              ),
              const Text('Unable to load the list of vendors'),
              const SizedBox(height: 4.0),
              TextButton(
                onPressed: () {
                  queryResult.refetch();
                },
                child: const Text('Retry reload'),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      final vendors = Vendors.fromJson(result.data!);

      body = _Body(vendors: vendors.vendors);
    }

    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: mainScaffoldBg),
      body: body,
    );
  }
}

class _Body extends StatelessWidget {
  final List<Vendor> vendors;

  const _Body({Key? key, required this.vendors}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SearchInput(onChanged: (val) {}),
        const SizedBox(height: 10.0),
        ListView.builder(
          itemBuilder: (context, index) {
            return Text(vendors[index].name);
          },
        ),
      ],
    );
  }
}

class _SearchInput extends HookWidget {
  final ValueChanged onChanged;

  const _SearchInput({Key? key, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final showClear = useState<bool>(false);
    final controller = useTextEditingController();
    controller.addListener(() {
      print('changed text: ${controller.text}');
      showClear.value = controller.text.isNotEmpty;
    });

    return Container(
      height: 40.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.white,
      ),
      child: Row(
        children: [
          if (showClear.value)
            SizedBox(
              width: 40.0,
              height: 40.0,
              child: Center(
                child: IconButton(
                  iconSize: 14.0,
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.text = "";
                    onChanged("");
                  },
                ),
              ),
            ),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Search',
                focusedBorder: InputBorder.none,
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                    vertical: 8, horizontal: controller.text.isEmpty ? 14 : 0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
