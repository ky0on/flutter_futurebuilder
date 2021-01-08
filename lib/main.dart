import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//
// [Flutter] FutureBuilderを使って非同期でWidgetを生成する - Qiita
// https://qiita.com/ysknsn/items/76c6326c74dc9059ff20
//

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: MyHomePage(),
      ),
      providers: [
        ChangeNotifierProvider(create: (context) => ItemModel()),
      ],
    );
  }
}

class MyHomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var _itemModel = Provider.of<ItemModel>(context, listen: false);

    Card _generateItemCard(String title) {
      return Card(
        child: ListTile(
          title: Text(title),
        )
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('FutureBuilder + Provider + ChangeNotifier'),
        actions: [
          IconButton(
            icon: Icon(Icons.update),
            // onPressed: () => _itemModel.random(),
            onPressed: () => _itemModel.fetchItems(),
          ),
        ],
      ),
      body: FutureBuilder(
        // future: _itemModel.random(),
        future: _itemModel.fetchItems(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Consumer<ItemModel>(
              builder: (BuildContext context, ItemModel value, Widget child) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  print('Showing CircularProgressIndicator...');
                  return Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                    itemCount: value.items.length,
                    itemBuilder: (context, index) {
                      return _generateItemCard(value.items[index].title);
                    },
                  );
                }
              }
          );
        }
      ),
    );
  }
}

class ItemModel extends ChangeNotifier {
  List<Item> _items = <Item>[];

  List<Item> get items => _items;

  Future<void> random() async {
    print('random() as been called.');

    await Future.delayed(
      Duration(seconds: 1),
    );

    List<Item> _newItems = <Item>[];
    var rng = Random();
    for (int i = 0; i < 5; i++) {
      String title = 'item' + rng.nextInt(99).toString();
      _newItems.add(Item(title));
    }

    _items = _newItems;
    notifyListeners();   // notify changes
  }

  Future<void> fetchItems() async {
    print('fetchItems() has been called.');
    const url = 'http://localhost:3000/items';
    final response = await http.get(url);
    final decodedData = json.decode(response.body) as List;
    if (decodedData == null) {
      return;
    }
    List<Item> _newItems = [];
    for (int i = 0; i < decodedData.length; i++) {
      Map<String, dynamic> _item = decodedData[i];
      String title = _item['title'];
      _newItems.add(Item(title));
    }
    _items = _newItems;
    notifyListeners();
  }
}

class Item {
  final String title;

  const Item(this.title);
}