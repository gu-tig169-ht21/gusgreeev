import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    title: 'To Do',
    home: FirstSide(),
  ));
}

class CBState {
  final String title;
  bool item;

  CBState({
    required this.title,
    this.item = false,
  });
}

final todos = [
  CBState(title: 'Städa'),
  CBState(title: 'Plugga'),
  CBState(title: 'Laga mat'),
];

//Första sidan
class FirstSide extends StatefulWidget {
  const FirstSide({Key? key}) : super(key: key);
  @override
  _FirstSideState createState() => _FirstSideState();
}

class _FirstSideState extends State<FirstSide> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Colors.grey,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SecondSide()),
          ).then(
            (value) => setState(() {}),
          );
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text("TIG169 TO-DO"),
        titleTextStyle: const TextStyle(
          color: Color(0xffffffff),
          fontSize: 20,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            color: Colors.white,
            iconSize: 30,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SecondSide()));
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(3),
        children: [
          ...todos.map(doBox).toList(),
        ],
      ),
    );
  }

//Checkbox + listan + delete icon
  Widget doBox(CBState checkbox) {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      value: checkbox.item,
      //Texten/listan
      title: Text(checkbox.title),
      onChanged: (value) => setState(() => checkbox.item = value!),
      //Delete Icon
      secondary: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.delete),
      ),
    );
  }
}

//Andra sidan
class SecondSide extends StatelessWidget {
  const SecondSide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: AppBar(
            title: const Text("TIG169 TO-DO"),
            backgroundColor: Colors.grey,
          )),
      body: Center(
        child: ListView(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'What are you going to do?'),
              ),
            ),
            Container(
              child: const Icon(
                Icons.add,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
