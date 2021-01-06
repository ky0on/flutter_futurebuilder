import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';

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
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
      providers: [
        ChangeNotifierProvider(create: (context) => ItemModel()),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  /*
  Future<String> _getFutureValue() async {
    // 擬似的に通信中を表現するために１秒遅らせる
    await Future.delayed(
      Duration(seconds: 5),
    );
    return Future.value("データの取得に成功しました");
  }
  */

  @override
  Widget build(BuildContext context) {
    var _itemModel = Provider.of<ItemModel>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.update),
            onPressed: () => _itemModel.random(),
          ),
        ],
      ),
      body: Consumer<ItemModel>(
        builder: (BuildContext context, ItemModel value, Widget child) {
          return ListView.builder(
            itemCount: value.items.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(value.items[index].title),
                ),
              );
            },
          );
        }
      ),
    );
  }
}
        // child: Center(
        //   child: FutureBuilder(
        //     // future: _getFutureValue(),
        //     builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        //       if (snapshot.hasData) {
        //         return Text(snapshot.data);
        //       } else {
        //         // return Text('Waining...');
        //         return CircularProgressIndicator();
        //       }
        //     },

class ItemModel extends ChangeNotifier {
  List<Item> _items = <Item>[];

  List<Item> get items => _items;

  void random() {
    _items = <Item>[];
    var rng = Random();
    for (var i = 0; i < 5; i++) {
      String title = 'item' + rng.nextInt(9).toString();
      _items.add(Item(title));
    }
    notifyListeners();   // notify changes
  }
}

class Item {
  final String title;

  const Item(this.title);
}
