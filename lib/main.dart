import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_4/API.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => (Todolist()),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.brown),
      title: 'To Do',
      home: const FirstSide(),
    ),
  ));
}

class TodoTask {
  String title;
  bool item;
  String id;

  TodoTask(this.title, this.item, this.id);

  void done(TodoTask title) {
    item = !item;
  }
}

class Todolist with ChangeNotifier {
  List<TodoTask> _list = [];

  List<TodoTask> get list => _list;

  String _filterSetting = 'all';

  String get filterSetting => _filterSetting;

  Future getlist() async {
    List<TodoTask> list = (await Api.getList()) as List<TodoTask>;
    _list = list;
    notifyListeners();
  }

  void isDone(TodoTask title, item, id) async {
    _list = (await Api.updateList(title.title, item, id)) as List<TodoTask>;
    notifyListeners();
  }

  void removeTODo(TodoTask title) async {
    _list = (await Api.deleteList(title.id)) as List<TodoTask>;
    notifyListeners();
  }

  void addTodo(TodoTask title, item) async {
    _list = (await Api.postList(title.title, item)).cast<TodoTask>();
    notifyListeners();
  }

  void setFilterBy(String filterSetting) {
    _filterSetting = filterSetting;
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
  late Future<List<TodoTask>> futureList;

  @override
  void initState() {
    super.initState();
    futureList = Api.getList() as Future<List<TodoTask>>;
  }

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
                  onSelected: (String value) {
                    updateList(title) {}
                    Provider.of<Todolist>(context, listen: false)
                        .setFilterBy(value);
                  },
                  itemBuilder: (context) => [
                        const PopupMenuItem(
                          child: Text("All"),
                          value: 'all',
                        ),
                        const PopupMenuItem(
                          child: Text("Done"),
                          value: 'some',
                        ),
                        const PopupMenuItem(child: Text("Undone"), value: 'no'),
                      ])
            ]),
        body: Consumer<Todolist>(
            builder: (context, state, child) =>
                _list(_getFilteredList(state.list, state.filterSetting))),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            var newTodo = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SecondSide(TodoTask('', false, '')),
              ),
            );

            /*FutureBuilder<List<TodoTask>>(
              future: futureList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return _list(_getFilteredList);
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            );*/
            if (newTodo != null) {
              Provider.of<Todolist>(context, listen: false)
                  .addTodo(newTodo, false);
            }
          },
        ));
  }

  List<TodoTask> _getFilteredList(allItems, filterSetting) {
    if (filterSetting == 'all') return allItems;
    if (filterSetting == 'some') {
      return allItems.where((item) => item.done == true).toList();
    }
    if (filterSetting == 'no') {
      return allItems.where((item) => item.done == false).toList();
    }
    return allItems;
  }

  Widget _list(title) {
    return ListView.builder(
        itemBuilder: (context, index) => _doBox(title[index]),
        itemCount: title.length);
  }

  Widget _doBox(TodoTask checkbox) {
    return CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        value: checkbox.item,
        activeColor: Colors.brown,
        title: Text(
          checkbox.title,
          style: TextStyle(
            fontSize: 20,
            decoration: checkbox.item ? TextDecoration.lineThrough : null,
          ),
        ),
        onChanged: (value) => setState(() => checkbox.item = value!),
        secondary: IconButton(
            icon: const Icon(
              Icons.clear,
              color: Colors.brown,
            ),
            onPressed: () async {
              setState(() {
                deleteList() {}
                var state = Provider.of<Todolist>(context, listen: false);
                state.removeTODo(checkbox);
              });
            }));
  }
}

//Andra sidan
class SecondSide extends StatefulWidget {
  TodoTask checkbox;

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

  final _formKey = GlobalKey<FormState>();

  _SecondSideState(TodoTask checkbox) {
    title = checkbox.title;
    item = checkbox.item;
    _controller = TextEditingController(text: checkbox.title);

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
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            TextFormField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'What are you going to do?'),
                controller: _controller,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Write something to do...';
                  } else {}
                }),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.brown,
                      textStyle: const TextStyle(fontSize: 15)),
                  child: const Text('ADD'),
                  onPressed: () async {
                    Api.postList(_controller.text, false);
                    Api.getList();
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(
                          context, TodoTask(_controller.text, false, ''));
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
