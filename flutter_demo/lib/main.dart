import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'util/NetUtils.dart';

void main() => runApp(new MyApp());

//APP的 主框架
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

//APP 的首页
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextStyle titleTextStyle = new TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold, color: Color(0xFF000000));
  TextStyle subtitleStyle = new TextStyle(color: const Color(0xFFB5BDC0), fontSize: 12.0);

  var listData;
  var baseUrl = 'https://pre.dealglobe.com';

  //构造方法
  _MyHomePageState(){

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewsList(true);
  }

  getNewsList(bool isLoadMore){
    String url = baseUrl + '/api/v6/news.json';
    NetUtils.get(url).then((data){
      print(data);
      if(data != null){
        var jsonData = json.decode(data);
        var _baseData = jsonData["meta"];
        var _listData = jsonData["news"];
        print(_listData);
        setState(() {
          listData = _listData;
        });
      }
    });
  }

  Widget renderRow(i){

    var itemData = {};
    if(listData != null){
      itemData = listData[i];
    }

    var imageUrl = 'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1534417292575&di=8484f38d8418c95713367ba006e00b6a&imgtype=0&src=http%3A%2F%2Fwww.hinews.cn%2Fpic%2F003%2F008%2F797%2F00300879752_3464b129.jpg';
    var thumbUrl = 'https://gss1.bdstatic.com/9vo3dSag_xI4khGkpoWK1HF6hhy/baike/c0%3Dbaike180%2C5%2C5%2C180%2C60/sign=c96364ee4a086e067ea5371963611091/d6ca7bcb0a46f21fcff3a68cf0246b600d33ae2e.jpg';

    //decoration 修饰的意思
    var thumbImg = new Container(
      margin: const EdgeInsets.all(0.0),
      decoration: new BoxDecoration(
        shape: BoxShape.rectangle,
        color: const Color(0xFFECECEC),
        image: new DecorationImage(
            image:new  NetworkImage(itemData['image_large_banner']),
            fit: BoxFit.fill,
        ),
      ),
    );

    var timeRow = new Row(
      children: <Widget>[
        new Container(
          width: 20.0,
          height: 20.0,
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFECECEC),
            image: new DecorationImage(
              image: new NetworkImage(thumbUrl),
              fit: BoxFit.cover,
            ),
            border: new Border.all(
              color: const Color(0xFFECECEC),
              width: 2.0,
            ),
          ),
        ),
        new Padding(
          padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
          child: new Text(
            '2018-08-08',
            style: subtitleStyle,
          ),
        ),
        new Expanded(
          flex: 1,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new Text('评论数：0',style: subtitleStyle),
            ],
          ),
        )
      ],
    );

    var row = new Row(

      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.all(6.0),
          child: new Container(
            width: 100.0,
            height: 80.0,
            color: const Color(0xFFECECEC),
            child: new Center(
              child: thumbImg,
            ),
          ),
        ),
        new Expanded(

          child: new Padding(
            padding: const EdgeInsets.all(6.0),
            child: new Column(
              mainAxisAlignment:MainAxisAlignment.start,
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new Expanded(
                      flex:1,
                      child: new Text(itemData['title_zh'], style: titleTextStyle,),
                    ),
                  ],
                ),
                new Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                  child: timeRow,
                ),
              ],
            ),
          ),
        )
      ],
    );

    return new InkWell(
      child: row,
    );
  }

  Future<Null> _pullToRefresh() async {
    return null;
  }

  RefreshIndicator getListView(){
    Widget listView = new ListView.builder(
      itemBuilder: (context, i) => renderRow(i),
      itemCount:listData==null ? 0 : listData.length,
    );
    return new RefreshIndicator(child: listView, onRefresh: _pullToRefresh); // ignore: missing_identifier
  }

  //相当于 render
  @override
  Widget build(BuildContext context) {

    RefreshIndicator listView = getListView();

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: listView, // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
