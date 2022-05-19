import "package:flutter/material.dart";
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ms_undraw/ms_undraw.dart';

import '../gql/gql.dart';
import '../models/model.dart';
import '../constants/constants.dart';
import '../components/components.dart';

class SelectVendorPage extends HookWidget {
  final String title;

  const SelectVendorPage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final queryResult = useQuery(QueryOptions(
        document: vendorsQuery, fetchPolicy: FetchPolicy.cacheAndNetwork));
    final result = useState<QueryResult>(queryResult.result);

    Widget body;

    if (result.value.isLoading && result.value.data == null) {
      body = const Center(
        child: CircularProgressIndicator(),
      );
    } else if (result.value.hasException) {
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
      final vendors = Vendors.fromJson(result.value.data!);

      body = _Body(
        vendors: vendors.vendors,
        onRefresh: () async {
          final results = await queryResult.refetch();
          if (results != null) {
            result.value = results;
          }
          return;
        },
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: mainScaffoldBg),
      backgroundColor: mainScaffoldBg,
      body: body,
    );
  }
}

class _Body extends HookWidget {
  final List<Vendor> vendors;
  final Future Function() onRefresh;

  const _Body({Key? key, required this.vendors, required this.onRefresh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vendorList = useState<List<Vendor>>(vendors);
    final searchString = useState<String>('');
    useEffect(() {
      vendorList.value = vendors
          .where((vendor) => vendor.name
              .toLowerCase()
              .contains(searchString.value.toLowerCase()))
          .toList();
      return null;
    }, [searchString.value, vendors]);

    var creating = false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SearchInput(onChanged: (val) {
          searchString.value = val;
        }),
        const SizedBox(height: 20.0),
        if (vendorList.value.isNotEmpty)
          Expanded(
            child: RefreshIndicator(
              onRefresh: () {
                return onRefresh();
              },
              child: CustomAZListView(
                data: vendorList.value,
                children: [
                  for (var vendor in vendorList.value)
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                      child: _VendorEntry(
                        vendor: vendor,
                        onTap: () {},
                      ),
                    )
                ],
              ),
            ),
          ),
        if (vendorList.value.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(
              children: [
                const Text('Vendor not found.'),
                const SizedBox(width: 10.0),
                Expanded(
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      if (creating) {
                        return Text('Creating ${searchString.value}');
                      } else {
                        return ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              creating = true;
                            });
                            var result = await _createVendor(
                                context, searchString.value);
                            if (result.hasException) {
                              var snackBar = const SnackBar(
                                  content: Text(
                                      'Something unexpected happened, vendor was not created'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              Navigator.of(context).pop();
                            } else {
                              final vendor =
                                  Vendor.fromJson(result.data!['createVendor']);
                              Navigator.of(context).pop(vendor);
                            }
                          },
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                const TextSpan(text: 'Tap to create '),
                                TextSpan(
                                    text: searchString.value,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.black87,
                            ),
                            foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.white,
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Future<QueryResult> _createVendor(BuildContext context, String name) async {
    final cli = GraphQLProvider.of(context).value;
    var result = await cli.mutate(
      MutationOptions(
        document: mutationCreateVendor,
        variables: {
          'input': {
            'name': name,
          },
        },
      ),
    );
    return result;
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
      showClear.value = controller.text.isNotEmpty;
      onChanged(controller.text);
    });

    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
      child: Container(
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
                      vertical: 8,
                      horizontal: controller.text.isEmpty ? 14 : 0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VendorEntry extends StatelessWidget {
  final VoidCallback onTap;
  final Vendor vendor;

  const _VendorEntry({Key? key, required this.onTap, required this.vendor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(4.0),
          onTap: () {
            Navigator.of(context).pop(vendor);
          },
          splashColor: Colors.black12,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              color: Colors.transparent,
            ),
            child: Row(
              children: [
                Expanded(child: Text(vendor.name)),
                const Icon(FeatherIcons.chevronRight),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
