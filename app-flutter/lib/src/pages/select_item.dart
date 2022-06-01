import 'package:flutter/material.dart';

import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ms_undraw/ms_undraw.dart';

import '../constants/constants.dart';
import '../gql/gql.dart';
import '../models/model.dart';
import '../components/components.dart';

class SelectItemPage extends HookWidget {
  const SelectItemPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final queryResult = useQuery(QueryOptions(
        document: itemsQueryWithLabels,
        fetchPolicy: FetchPolicy.cacheAndNetwork));
    final result = queryResult.result;
    final searchStringValue = useState<String>('');

    Widget body;
    if (result.isLoading) {
      body = Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Loading items'),
                  SizedBox(width: 10.0),
                  Icon(FeatherIcons.coffee),
                ],
              ),
            ],
          ),
        ),
      );
    } else if (result.hasException) {
      body = Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UnDraw(
                  illustration: UnDrawIllustration.warning,
                  color: Colors.redAccent,
                  height: 150.0),
              const Text('Unable to load items')
            ],
          ),
        ),
      );
    } else {
      final items = Items.fromJson(result.data!);
      final filteredItems = items.items.where((item) => item.name
          .toLowerCase()
          .contains(searchStringValue.value.toLowerCase()));
      body = RefreshIndicator(
        onRefresh: () async {
          await queryResult.refetch();
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: _SearchField(
                  onChanged: (searchString) {
                    searchStringValue.value = searchString;
                  },
                  searchString: searchStringValue.value,
                ),
              ),
              const SizedBox(height: 20.0),
              if (filteredItems.isNotEmpty)
                Expanded(
                  child: CustomAZListView(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    data: filteredItems.toList(),
                    children: [
                      for (var item in filteredItems) _Item(item: item),
                    ],
                  ),
                ),
              if (filteredItems.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: _EmptySearchResult(
                      searchString: searchStringValue.value,
                      onCreate: () {
                        queryResult.refetch();
                      }),
                ),
            ],
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: mainScaffoldBg,
        appBar: AppBar(
          backgroundColor: mainScaffoldBg,
          title: Text(title),
          centerTitle: true,
        ),
        body: body,
      ),
    );
  }
}

class _SearchField extends HookWidget {
  const _SearchField(
      {Key? key, required this.onChanged, required this.searchString})
      : super(key: key);

  final ValueChanged<String> onChanged;
  final String searchString;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: searchString);
    final text = useState<String>(searchString);
    controller.addListener(() {
      text.value = controller.text;
      onChanged(text.value);
    });
    final focusNodeValue = useState<FocusNode>(FocusNode());
    focusNodeValue.value.requestFocus();

    return Container(
      height: 40.0,
      padding: const EdgeInsets.only(left: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 40.0,
            height: 40.0,
            child: Center(
              child: Icon(FeatherIcons.search, size: 18.0),
            ),
          ),
          Expanded(
            child: TextField(
              focusNode: focusNodeValue.value,
              // onChanged: (val) {
              // controller.text = val;
              // },
              controller: controller,
              // onChanged: onChanged,
              decoration: const InputDecoration(
                hintText: 'Search',
                focusedBorder: InputBorder.none,
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.only(top: 8, bottom: 8, right: 14),
              ),
              style: const TextStyle(color: Colors.black54),
            ),
          ),
          if (text.value.isNotEmpty)
            SizedBox(
              width: 40.0,
              height: 40.0,
              child: Center(
                child: IconButton(
                  iconSize: 14.0,
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.clear();
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({Key? key, required this.item}) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Material(
          color: const Color(0xFFF0F0F0),
          child: InkWell(
            splashColor: Colors.black12,
            onTap: () {
              Navigator.of(context).pop(item);
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Expanded(child: Text(item.name)),
                  const Icon(FeatherIcons.chevronRight),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptySearchResult extends HookWidget {
  final String searchString;
  final VoidCallback onCreate;

  const _EmptySearchResult(
      {Key? key, required this.searchString, required this.onCreate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final saving = useState<bool>(false);

    if (saving.value) {
      return RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          style: const TextStyle(color: Colors.black54),
          children: [
            const TextSpan(text: 'Creating '),
            TextSpan(
                text: searchString,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.black)),
            const TextSpan(text: '...'),
          ],
        ),
      );
    }
    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Text('Item not found.'),
          const SizedBox(width: 5.0),
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black87),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            onPressed: () {
              saving.value = true;
              _createItem(context, onCreate);
            },
            child: Text('Create $searchString',
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _createItem(BuildContext context, VoidCallback callback) {
    var cli = GraphQLProvider.of(context).value;
    cli
        .mutate(
      MutationOptions(document: mutationCreateItem, variables: {
        "input": {
          "name": searchString,
        }
      }),
    )
        .then((result) {
      if (!result.hasException) {
        callback();
      } else {
        const snackBar =
            SnackBar(content: Text('Unable to create item, try again later'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }
}
