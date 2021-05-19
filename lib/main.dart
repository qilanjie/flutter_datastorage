import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_study/todo_list.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'main.g.dart';
var box;

@HiveType(typeId: 1)
class Person extends HiveObject {
   Person({required this.name, required this.age, required this.friends,required this.created});

  @HiveField(0)
  late String name;

  @HiveField(1)
  late int age;

  @HiveField(2)
  late List<String> friends;

  @HiveField(3)
  late DateTime created;

  @override
  String toString() {
    return '$name: $age';
  }
}

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PersonAdapter());

   box = await Hive.openBox<Person>('test2Box');
   final person = Person(name : 'Dave',
  age :22,
  friends :['Linda', 'Marc', 'Anne'],
  created : DateTime.now())
    ;
//  await box.clear();
//  await box.add(person);

for(int i=0;i<box.length;i++){
  print(box.getAt(i)!.created);
}
//  print(box.getAt(0)!.created); // Dave: 22
  print(box.length);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      title: '山东中惠仪器有限公司',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(
        title: '主页',
        key: Key("home"),
      ),
      routes: {'/settings': (BuildContext context) => Settings()},
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({required Key key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<int> _counter;

  @override
  void initState() {
    super.initState();
    _counter = _prefs.then((SharedPreferences prefs) {
      return (prefs.getInt('counter') ?? 0);
    });
  }

  Future<void> testHive() async {
    var box = await Hive.openBox('testBox');

    var person = Person(name : 'Dave',
        age :22,
        friends :['Linda', 'Marc', 'Anne'],
        created : DateTime.now())
    ;

    await box.put('dave', person);

    print(box.get('dave')); // Dave: 22
  }

  Future<void> _initCounter() async {
    final SharedPreferences prefs = await _prefs;
    final int counter = (prefs.getInt('counter') ?? 0);

    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.

      _counter = prefs.setInt("counter", counter).then((bool success) {
        return counter;
      });
    });
  }

  Future<void> _incrementCounter() async {
    final SharedPreferences prefs = await _prefs;
    final int counter = (prefs.getInt('counter') ?? 0) + 1;
    final  person = Person(name : 'Dave',
        age :22,
        friends :['Linda', 'Marc', 'Anne'],
        created : DateTime.now())
    ;
    await box.add(person);
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.

      _counter = prefs.setInt("counter", counter).then((bool success) {
        return counter;
      });
    });
  }

  Future<void> _clearZero() async {
    final SharedPreferences prefs = await _prefs;
await box.clear();
    setState(() {
      setState(() {
        _counter = prefs.setInt("counter", 0).then((bool success) {
          return 0;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[  Divider(
            height: 20,
          ),
            SizedBox(
              width: 200,
              height: 64,
              child: ElevatedButton(
                  onPressed: _clearZero,
                  child: Text(
                    "记录全部清空",
                    style: TextStyle(fontSize: 24),
                  ),
                  style: ButtonStyle(
                    shape:
                        MaterialStateProperty.all(const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    )),
                  )),
            ),
            Divider(
              height: 20,
            ),
            SizedBox(
                width: 200,
                height: 64,
                child:ElevatedButton(
              onPressed: _incrementCounter,
              style: ButtonStyle(
                shape:
                MaterialStateProperty.all(const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ))),
              child: Text(
                "新加一条记录",
                style: TextStyle(fontSize: 24),
              ),
            )),

            FutureBuilder<int>(
                future: _counter,
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const CircularProgressIndicator();
                    default:
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Text(
                          '你已经添加了  ${snapshot.data} 条记录${snapshot.data == 1 ? '' : '。'}.程序重启后数据会保存.'
                          ,
                          style: TextStyle(fontSize: 24),
                        );
                      }
                  }
                }),
            Expanded(
              child: ValueListenableBuilder<Box<Person>>(
                valueListenable: Hive.box<Person>('test2Box').listenable(),
                builder: (context, box, _) {
                  var todos = box.values.toList().cast<Person>();
                  // if (reversed) {
                  //   todos = todos.reversed.toList();
                  // }
                  todos=todos.reversed.toList();
                  return TodoList(todos);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){Navigator.pushNamed(context, '/settings');},
        tooltip: 'Setting',
        child: Icon(Icons.settings),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("设置"),
        leading: IconButton(
          iconSize: 36,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: Center(
        child: Text(
          "压强:${102.568.toStringAsFixed(3)}kPa",
          style: TextStyle(fontSize: 48),
        ),
      ),
    );
  }
}
