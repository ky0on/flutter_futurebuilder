import 'package:flutter/material.dart';

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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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

  Future<String> _getFutureValue() async {
    // 擬似的に通信中を表現するために１秒遅らせる
    await Future.delayed(
      Duration(seconds: 5),
    );
    return Future.value("データの取得に成功しました");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder(
          future: _getFutureValue(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data);
            } else {
              // return Text('Waining...');
              return CircularProgressIndicator();
            }
          },
        )
      ),
    );
  }
}
