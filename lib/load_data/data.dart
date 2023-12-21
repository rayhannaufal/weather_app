import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:weather_app/models/user_model.dart';

class CekData extends StatefulWidget {
  const CekData({super.key});

  @override
  State<CekData> createState() => _CekDataState();
}

class _CekDataState extends State<CekData> {
  late Box<UserModel> _myBox;

  @override
  void initState() {
    super.initState();
    _myBox = Hive.box("userDB");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User list")),
      body: ValueListenableBuilder(
        valueListenable: _myBox.listenable(),
        builder: (context, value, child) {
          if (_myBox.values.isEmpty) {
            return Center(
              child: Text("Belum Ada User"),
            );
          } else {
            return ListView.builder(
              itemCount: _myBox.values.length,
              itemBuilder: (context, index) {
                UserModel? data = _myBox.getAt(index);
                return ListTile(
                  title: Text(data!.username),
                  subtitle: Text(data.password),
                );
              },
            );
          }
        },
      )
    );
  }
}
