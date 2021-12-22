import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'model.dart';

class SecondPage extends StatefulWidget {
  final TodoTask checkbox;

  const SecondPage(this.checkbox, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SecondPageState();
  }
}

class SecondPageState extends State<SecondPage> {
  late String title;
  late bool item;
  late TodoTask checkbox = TodoTask(title: '');

  late TextEditingController _controller;

  final _formKey = GlobalKey<FormState>();

  SecondSideState() {
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

  @override
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
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(context, TodoTask(title: _controller.text));
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
