import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => (Todolist()),
    child: MaterialApp(
      theme: ThemeData(primarySwatch: Colors.grey),
      title: 'To Do',
      home: const FirstSide(),
    ),
  ));
}

class CBState {
  String title;
  bool item;
  CBState(this.title, this.item);
}

class Todolist with ChangeNotifier {
  final List<CBState> _list = [];
  List<CBState> get list {
    return _list;
  }

  void removeTODo(CBState title) {
    _list.remove(title);
    notifyListeners();
  }

  void addTodo(CBState title) {
    _list.add(title);
    notifyListeners();
  }
}

//Första sidan
class FirstSide extends StatefulWidget {
  const FirstSide({Key? key}) : super(key: key);

  @override
  _FirstSideState createState() => _FirstSideState();
}

class _FirstSideState extends State<FirstSide> {
  var filterSetting = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("TIG169 TO-DO"),
          titleTextStyle: const TextStyle(
            color: Color(0xffffffff),
            fontSize: 20,
          ),
          actions: [
            PopupMenuButton(
                itemBuilder: (context) => [
                      PopupMenuItem(
                          child: const Text("All"), value: 1, onTap: () {}),
                      const PopupMenuItem(
                        child: Text("Done"),
                        value: 2,
                      ),
                      const PopupMenuItem(
                        child: Text("Undone"),
                      ),
                    ])
          ]),
      body: Consumer<Todolist>(
          builder: (context, state, child) =>
              _list(getFilteredList(state.list, filterSetting))),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Colors.grey,
        onPressed: () async {
          var newTodo = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SecondSide(CBState('', false)),
            ),
          );
          if (newTodo != null) {
            Provider.of<Todolist>(context, listen: false).addTodo(newTodo);
          }
        },
      ),
    );
  }

  Widget _list(title) {
    return ListView.builder(
        itemBuilder: (context, index) => _doBox(title[index]),
        itemCount: title.length);
  }

//Checkbox + listan + delete icon
  Widget _doBox(CBState checkbox) {
    return CheckboxListTile(
      //checkbox
      controlAffinity: ListTileControlAffinity.leading,
      value: checkbox.item,
      activeColor: Colors.grey,
      //Texten/listan
      title: Text(
        checkbox.title,
        style: TextStyle(
          fontSize: 20,
          decoration: checkbox.item ? TextDecoration.lineThrough : null,
        ),
      ),
      onChanged: (value) => setState(() => checkbox.item = value!),
      //Delete Icon
      secondary: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () async {
            var state = Provider.of<Todolist>(context, listen: false);
            state.removeTODo(checkbox);
          }),
    );
  }
}

List getFilteredList(allItems, settings) {
  if (settings == "All") return allItems;
  if (settings == "Done") {
    return [];
  }
  return allItems;
}

//Andra sidan
class SecondSide extends StatefulWidget {
  final CBState checkbox;

  SecondSide(this.checkbox);

  @override
  State<StatefulWidget> createState() {
    return _SecondSideState(checkbox);
  }
}

class _SecondSideState extends State<SecondSide> {
  late String title;
  late bool item;
  late TextEditingController _controller;

  _SecondSideState(CBState thing) {
    title = thing.title;
    item = thing.item;

    _controller = TextEditingController(text: thing.title);

    _controller.addListener(() {
      setState(() {
        title = _controller.text;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "TIG169 TO-DO",
        ),
        titleTextStyle: const TextStyle(
          color: Color(0xffffffff),
          fontSize: 20,
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            TextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'What are you going to do?'),
              controller: _controller,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.grey,
                    textStyle: const TextStyle(fontSize: 15)),
                child: const Text('ADD'),
                onPressed: () {
                  Navigator.pop(context, CBState(_controller.text, false));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
