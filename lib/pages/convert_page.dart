import 'package:flutter/material.dart';


class ConvertPage extends StatefulWidget {
  const ConvertPage({super.key});

  @override
  State<ConvertPage> createState() => _ConvertPageState();
}

class _ConvertPageState extends State<ConvertPage> {

  static const List<String> uang = <String>['USD', 'JPY', 'EUR'];

  // Controller input & output
  TextEditingController input = TextEditingController();
  TextEditingController output = TextEditingController();


  String dropdownValue = 'USD';

  // function kurs mata uang
  convertMoney(param) {
    double masukan = double.parse(input.text);
    switch (param) {
      case 'USD':
        double hasil = masukan / 15424.30;
        output.text = hasil.toStringAsFixed(2);
      case 'EUR':
        double hasil = masukan / 16839.48;
        output.text = hasil.toStringAsFixed(2);
      case 'JPY':
        double hasil = masukan / 103.15;
        output.text = hasil.toStringAsFixed(2);
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text('Convert Money'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15)
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'Kurs Mata Uang',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 24
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownMenu<String>(
                    initialSelection: uang.first,
                    onSelected: (String? value) {
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                    dropdownMenuEntries: uang.map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                        value: value, 
                        label: value
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: output,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: dropdownValue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: input,
                    onChanged: (value) {
                      convertMoney(dropdownValue);
                    },
                    decoration: const InputDecoration(
                      labelText: 'Enter rupiah'
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}