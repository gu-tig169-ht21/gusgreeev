import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterletsgo/secondpage.dart';
import 'package:provider/provider.dart';
import 'model.dart';

void main() async {
  TodolistProvider todoList = TodolistProvider();
  await todoList.getList();
  runApp(ChangeNotifierProvider(
    create: (context) => todoList,
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.brown),
      title: 'To Do',
      home: const FirstPage(),
    ),
  ));
}

//Första sidan
class FirstPage extends StatelessWidget {
  const FirstPage({Key? key}) : super(key: key);

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
                    Provider.of<TodolistProvider>(context, listen: false)
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
        body: Consumer<TodolistProvider>(
            builder: (context, state, child) =>
                _list(getFilteredList(state.list, state.filterSetting))),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            var newtodo = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SecondPage(TodoTask(title: '', id: '')),
              ),
            );
            if (newtodo != null) {
              Provider.of<TodolistProvider>(context, listen: false)
                  .addTodo(newtodo.title);
            }
          },
        ));
  }

  Widget _doBox(
    TodoTask checkbox,
    BuildContext context,
  ) {
    return CheckboxListTile(
        secondary: IconButton(
            icon: const Icon(
              Icons.clear,
              color: Colors.brown,
            ),
            onPressed: () async {
              {
                Provider.of<TodolistProvider>(context, listen: false)
                    .removeToDo(checkbox);
              }
            }),
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
        onChanged: (bool? item) {
          Provider.of<TodolistProvider>(context, listen: false)
              .upDateTodo(checkbox);
        });
  }

  Widget _list(todo) {
    return ListView.builder(
        itemBuilder: (context, index) => _doBox(todo[index], context),
        itemCount: todo.length);
  }
}
